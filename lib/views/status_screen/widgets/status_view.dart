// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_wise/Service/status/status_services.dart';
import 'dart:async';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class StatusViewPage extends StatefulWidget {
  final String statusId;
  final Map<String, dynamic> statusMap;

  const StatusViewPage({
    super.key,
    required this.statusId,
    required this.statusMap,
  });

  @override
  StatusViewPageState createState() => StatusViewPageState();
}

class StatusViewPageState extends State<StatusViewPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<Map<String, dynamic>> statusData = [];

  @override
  void initState() {
    super.initState();
    fetchStatusData();
  }

  void fetchStatusData() async {
    // Use the provided statusMap to populate the statusData list.
    statusData.add(widget.statusMap);
    // Start a timer to automatically switch images every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (timer) {
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

  deleteStatus(String statusId) async {
    try {
      await FireStoreStatusMethods().deleteStatus(statusId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Viewer'),
      ),
      body: statusData.isNotEmpty
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemCount: statusData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            statusData[index]['statusUrl'],
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                              content: statusData[index]['description']),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.delete),
                    onPressed: () {
                      // Delete the current image
                      deleteStatus(widget.statusId);

                      Navigator.of(context).pop();

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
                ),
              ],
            )
          : const CustomIndicator(),
    );
  }
}
