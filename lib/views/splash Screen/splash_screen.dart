import 'package:message_wise/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:message_wise/Controllers/profile/profile_bloc_bloc.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_wise/views/onBoard%20Screen/onboard_screen.dart';

import '../../util.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    authCheck(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: colorWhite,
        child: Stack(children: [
          Center(
            child: Image.asset(
              "assets/images/splashcartoon.png",
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              Text(
                "Message Wise",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

//check useer logined or not and navigating to next screeen ===================================
Future authCheck(
  BuildContext context,
) async {
  await Future.delayed(const Duration(seconds: 2));

  final user = FirebaseAuth.instance.currentUser;

  if (context.mounted) {
    if (user != null) {
      context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
      context.read<GroupBloc>().add(FetchGroupsEvent());

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, OnBoardScreen.routeName, (route) => false);
    }
  }
}
