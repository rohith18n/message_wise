import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/chat%20screen/chat_screen.dart';
import 'package:message_wise/views/new%20chat%20screen/contacts_screen.dart';
import 'package:message_wise/views/posts_screen/feed_screen.dart';
import 'package:message_wise/views/settings%20screen/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../Controllers/profile/profile_bloc_bloc.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  HomeScreen({super.key});
  final List screens = [
    // const CallScreen(),
    const FeedScreen(),
    ChatScreen(),
    ContactScreen(),
    SettingsScreen(),
  ];
  final ValueNotifier<int> _index = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: ValueListenableBuilder(
          valueListenable: _index,
          builder: (context, index, child) => screens[index],
        ),
        bottomNavigationBar: GNav(
          gap: getProportionateScreenHeight(10),
          backgroundColor: colorWhite,
          selectedIndex: _index.value,
          iconSize: getProportionateScreenHeight(27),
          activeColor: kPrimaryColor,
          color: kTextColor,
          onTabChange: (value) {
            _index.value = value;
          },
          tabs: const [
            GButton(
              icon: CupertinoIcons.camera,
              text: 'Feeds',
            ),
            GButton(
              icon: CupertinoIcons.chat_bubble_2,
              text: 'Chats',
            ),
            GButton(
              icon: CupertinoIcons.person_2,
              text: 'All Users',
            ),
            GButton(
              icon: CupertinoIcons.settings,
              text: 'Settings',
            )
          ],
        ));
  }
}

class ChatIcon extends StatefulWidget {
  const ChatIcon({
    super.key,
  });

  @override
  State<ChatIcon> createState() => _ChatIconState();
}

class _ChatIconState extends State<ChatIcon> with WidgetsBindingObserver {
  @override
  void initState() {
    context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
    WidgetsBinding.instance.addObserver(this);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isOnline": true});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      log("resumed");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": true});
    } else if (state == AppLifecycleState.paused) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": false});
      log("paused");
    } else if (state == AppLifecycleState.inactive) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": false});
      log("inactive");
    } else if (state == AppLifecycleState.detached) {
      log("ditached");
    } else {
      log(state.toString());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isOnline": false});

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Icon(CupertinoIcons.chat_bubble_2);
  }
}
