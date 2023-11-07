import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/posts_screen/widgets/post_card.dart';
import 'package:message_wise/views/status_screen/add_statuses.dart';

class SeeStatus extends StatefulWidget {
  const SeeStatus({super.key});

  @override
  State<SeeStatus> createState() => _SeeStatusState();
}

class _SeeStatusState extends State<SeeStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
          child: Text(
            "Updates",
            style: appBarHeadingStyle,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: getProportionateScreenWidth(20)),
            child: IconButton(
              icon: const Icon(CupertinoIcons.camera_on_rectangle),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddStatus()));
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
