// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/Service/status/status_services.dart';
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

  StatusViewPageState(List<Map<String, dynamic>> statuses) {
    statusData = statuses;
    startAutoSwitchTimer();
  }

  void startAutoSwitchTimer() {
    // Start a timer to automatically switch images every 30 seconds
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_currentPageIndex < statusData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      } else {
        // If at the last image, go back to the first image
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
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
                                  // If the deleted image was the last, navigate to the previous image
                                  _currentPageIndex = statusData.length - 1;
                                }
                                _pageController.jumpToPage(_currentPageIndex);
                              } else {
                                // Handle when there are no more images
                                // You may want to navigate back to the previous screen or show a message
                              }
                            },
                          ),
                      ],
                    ),
                    Expanded(
                      child: Image.network(
                        statusUrl ?? '',
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
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
      // You can add any additional logic you need here after deleting the status.
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
}
// Now, the delete button will only be shown for the user's own status.




