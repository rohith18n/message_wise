import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/settings%20screen/widgets/about.dart';
import 'package:message_wise/views/settings%20screen/widgets/custom_alertdialog.dart';
import 'package:message_wise/views/settings%20screen/widgets/privacy_policy.dart';
import 'package:message_wise/views/settings%20screen/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:message_wise/views/settings%20screen/widgets/profile_menu.dart';
import 'package:message_wise/views/settings%20screen/widgets/terms_and_conditions.dart';
import '../../Controllers/profile/profile_bloc_bloc.dart';
import '../splash Screen/splash_screen.dart';

final user = FirebaseAuth.instance.currentUser;

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SafeArea(
        child: Column(
          children: [
            const ProfileImage(),
            sizeHeight15,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                  builder: (context, state) {
                    if (state is LoadCurrentUserState) {
                      return CustomText(
                        content: state.currentUser.username ?? "",
                        colour: kTextColor,
                        size: getProportionateScreenHeight(20),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
              ],
            ),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "About us",
              icon: "assets/icons/Flash Icon.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Terms and Conditions",
              icon: "assets/icons/Bell.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndConditions(),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "privacy Policy",
              icon: "assets/icons/Lock.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                        title: "Confirm Log Out",
                        content: "Are you sure you want to log out?",
                        actionName: "Log Out",
                        press: () async {
                          final gg = GoogleSignIn();

                          gg.disconnect();
                          FirebaseFirestore.instance.clearPersistence();
                          await FirebaseAuth.instance.signOut();

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SplashScreen(),
                                ),
                                (route) => false);
                          }
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
