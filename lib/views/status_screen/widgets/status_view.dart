import 'package:flutter/material.dart';
import 'dart:async';

class StatusViewPage extends StatefulWidget {
  const StatusViewPage({super.key});

  @override
  StatusViewPageState createState() => StatusViewPageState();
}

class StatusViewPageState extends State<StatusViewPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<String> statusImages = [
    'image1.jpg', // Replace with actual image URLs or paths
    'image2.jpg',
    'image3.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Start a timer to automatically switch images every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_currentPageIndex < statusImages.length - 1) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Viewer'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemCount: statusImages.length,
            itemBuilder: (context, index) {
              return Image.network(statusImages[index], fit: BoxFit.cover);
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Delete the current image
                setState(() {
                  statusImages.removeAt(_currentPageIndex);
                });

                if (statusImages.isNotEmpty) {
                  // If there are more images, go to the next image
                  if (_currentPageIndex >= statusImages.length) {
                    _currentPageIndex = statusImages.length - 1;
                  }
                  _pageController.jumpToPage(_currentPageIndex);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
