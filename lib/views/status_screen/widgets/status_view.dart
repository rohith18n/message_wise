// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/service/status/status_services.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'dart:async';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class StatusViewPage extends StatefulWidget {
  final List<Map<String, dynamic>> statuses;

  const StatusViewPage({Key? key, required this.statuses}) : super(key: key);

  @override
  StatusViewPageState createState() => StatusViewPageState(statuses);
}

class StatusViewPageState extends State<StatusViewPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<Map<String, dynamic>> statusData = [];
  double _progressValue = 0.0;
  late Timer _timer;

  StatusViewPageState(List<Map<String, dynamic>> statuses) {
    statusData = statuses;
    startAutoSwitchTimer();
  }

  void startAutoSwitchTimer() {
    const duration = Duration(seconds: 15);
    const interval = Duration(milliseconds: 500);
    int steps = (duration.inMilliseconds / interval.inMilliseconds).floor();

    _timer = Timer.periodic(interval, (timer) {
      if (_progressValue < 1.0) {
        setState(() {
          _progressValue += 1.0 / steps;
        });
      } else {
        timer.cancel();
        if (_currentPageIndex < statusData.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
        // Restart the progress indicator after 15 seconds
        restartProgressIndicator();
      }
    });
  }

  void restartProgressIndicator() {
    // Reset the progress value to 0
    setState(() {
      _progressValue = 0.0;
    });

    // Start the timer again for the next cycle
    startAutoSwitchTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(),
      body: statusData.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _progressValue = 0.0;
                });
              },
              itemCount: statusData.length,
              itemBuilder: (context, index) {
                final user = statusData[index]['user'] as Map<String, dynamic>;
                final statusUrl = user['statusUrl'] as String?;
                final description = user['description'] as String?;
                final profileImage = user['profImage'] as String?;
                final username = user['username'] as String?;
                final datePublished = user['datePublished'] as Timestamp;

                // Check if the current user is the owner of the status
                final isCurrentUserStatus = currentUserUid == user['uid'];

                return Column(
                  children: [
                    Row(
                      children: [
                        // Profile picture
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileImage ?? ''),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username
                              CustomText(
                                content: username ?? '',
                                size: 18,
                                weight: FontWeight.bold,
                              ),
                              // Uploaded time
                              CustomText(
                                content: DateFormat('EEE, hh:mm a z')
                                    .format(datePublished.toDate()),
                                size: 14,
                                colour: kTextColor,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Show the delete button only if the current user is the owner of the status
                        if (isCurrentUserStatus)
                          IconButton(
                            icon: const Icon(CupertinoIcons.delete),
                            onPressed: () {
                              // Delete the current image
                              deleteStatus(
                                  statusData[_currentPageIndex]['userId']);
                              if (statusData.isNotEmpty) {
                                if (_currentPageIndex >= statusData.length) {
                                  _currentPageIndex = statusData.length - 1;
                                }
                                _pageController.jumpToPage(_currentPageIndex);
                              } else {
                                // Handle when there are no more images
                              }
                            },
                          ),
                      ],
                    ),
                    // LinearProgressIndicator
                    LinearProgressIndicator(
                      value: _progressValue,
                      color: kPrimaryColor,
                    ),
                    // Custom progress indicator
                    CustomProgressIndicator(
                      totalSteps: statusData.length,
                      currentStep: _currentPageIndex + 1,
                    ),
                    Expanded(
                      child: Image.network(
                        statusUrl ?? '',
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(30)),
                      child: CustomText(
                        content: description ?? '',
                        size: 18,
                      ),
                    ),
                  ],
                );
              },
            )
          : const CustomIndicator(),
    );
  }

  deleteStatus(String statId) async {
    try {
      await FireStoreStatusMethods().deleteStatus(statId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CustomProgressIndicator({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalSteps,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < currentStep ? kPrimaryColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
