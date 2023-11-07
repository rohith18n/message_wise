// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/service/posts/posts_services.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/posts_screen/widgets/comment_screen.dart';
import 'package:message_wise/views/posts_screen/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(5),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(4),
                horizontal: getProportionateScreenWidth(16),
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: getProportionateScreenWidth(16),
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'].toString(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            content: widget.snap['username'].toString(),
                            colour: kTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.snap['uid'].toString() ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                                onTap: () {
                                                  deletePost(
                                                    widget.snap['postId']
                                                        .toString(),
                                                  );
                                                  // remove the dialog box
                                                  Navigator.of(context).pop();
                                                }),
                                          )
                                          .toList()),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        )
                      : Container(),
                ],
              ),
            ),
            // IMAGE SECTION OF THE POST
            GestureDetector(
              onDoubleTap: () {
                FireStoreMethods().likePost(
                  widget.snap['postId'].toString(),
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // LIKE, COMMENT SECTION OF THE POST
            Row(
              children: <Widget>[
                LikeAnimation(
                  isAnimating: widget.snap['likes']
                      .contains(FirebaseAuth.instance.currentUser!.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.snap['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () => FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.snap['likes'],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.bubble_left,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {}),
                ))
              ],
            ),
            //DESCRIPTION AND NUMBER OF COMMENTS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        '${widget.snap['likes'].length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(8),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: kTextColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLen comments',
                        style: const TextStyle(
                          fontSize: 16,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        color: kTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
