// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/posts_screen/add_posts_screen.dart';
import 'package:message_wise/views/posts_screen/widgets/post_card.dart';
import 'package:message_wise/views/status_screen/see_statuses.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Import other necessary packages and files

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
          child: Text(
            "Feeds",
            style: appBarHeadingStyle,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: getProportionateScreenWidth(20)),
            child: IconButton(
              icon: const Icon(CupertinoIcons.camera_on_rectangle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600 || kIsWeb) {
            // If the screen width is greater than or equal to 600 (tablet/desktop) or running on web
            return Column(
              children: [
                const Expanded(
                  flex: 2,
                  child: SeeStatus(),
                ),
                Expanded(
                  flex: 3,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CustomIndicator();
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            // If the screen width is less than 600 (mobile)
            return Column(
              children: [
                const SeeStatus(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CustomIndicator();
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
