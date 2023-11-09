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

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
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
                        builder: (context) => const AddPostScreen()));
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator();
          }
          return Column(
            children: [
              const SeeStatus(),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
