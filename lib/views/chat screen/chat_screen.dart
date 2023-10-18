import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:message_wise/Models/user_model.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/chat%20screen/widget/custom_tab_bar.dart';
import 'package:message_wise/views/chat%20screen/widget/group_list.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/user_list.dart';
import 'package:message_wise/views/new%20group%20screen/new_group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../util.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<UserModels> users = [];
  final List<UserModels> connections = [];
  ValueNotifier<bool> isVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    log("chat screeen");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(60.0),

        //   child: ValueListenableBuilder(
        //     valueListenable: isVisible,
        //     builder: (context, value, child) => value
        //         ? FloatingActionButton(
        //             backgroundColor: Colors.white,
        //             onPressed: () {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => NewGroupScreen(
        //                       connections: connections,
        //                       isAddMemberScreen: false,
        //                     ),
        //                   ));
        //             },
        //             child: const Icon(Icons.group_add),
        //           )
        //         : const SizedBox.shrink(),
        //   ),
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            ValueListenableBuilder(
              valueListenable: isVisible,
              builder: (BuildContext context, value, Widget? child) => value
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(20)),
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.group),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewGroupScreen(
                                  connections: connections,
                                  isAddMemberScreen: false,
                                ),
                              ));
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            )
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(getProportionateScreenHeight(40)),
              child: CustomTabBar(
                onTap: (value) {
                  if (value == 1) {
                    isVisible.value = true;
                  } else {
                    isVisible.value = false;
                  }
                },
              )),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            //stream builder
            //listen users collecion firestore
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    users.clear();
                    for (var element in snapshot.data!.docs) {
                      if (FirebaseAuth.instance.currentUser!.uid !=
                          element.reference.id) {
                        users.add(UserModels(
                            uid: element.reference.id,
                            email: element.data()["email"],
                            username: element.data()["userName"] ?? "",
                            photo: element.data()["photo"],
                            state: UserConnections.connect));
                      }
                    }
                    // listen connections
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("connections")
                            .snapshots(),
                        builder: (context, snapshot) {
                          connections.clear();
                          if (snapshot.hasData) {
                            for (var connection in snapshot.data!.docs) {
                              for (var bot in users) {
                                if (bot.uid == connection.get('botid')) {
                                  connections.add(bot);
                                }
                              }
                            }

                            //tabar view
                            return TabBarView(
                              children: [
                                UsersListInContact(
                                  users: connections,
                                  iscontactScreen: false,
                                ),
                                GroupList()
                              ],
                            );
                          }

                          return const CustomIndicator();
                        });
                  }

                  return const CustomIndicator();
                }),
          ),
        ),
      ),
    );
  }
}
