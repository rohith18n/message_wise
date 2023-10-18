import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/settings%20screen/widgets/custom_alertdialog.dart';
import 'package:message_wise/views/settings%20screen/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:message_wise/views/settings%20screen/widgets/profile_menu.dart';
import '../../Controllers/profile/profile_bloc_bloc.dart';
import '../splash Screen/splash_screen.dart';

final user = FirebaseAuth.instance.currentUser;

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  SettingsScreen({super.key});

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
            Column(
              children: List.generate(
                  4,
                  (index) => ProfileMenu(
                      text: listdata[index][1], icon: listdata[index][0])),
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
                          // context.read<ChatBloc>().close();
                          // context.read<GroupFunctionalityBloc>().close();
                          // context.read<GchatBloc>().close();
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
                            // context.read<ChatBloc>().add(ChatInitialEvent());
                            // context.read<GchatBloc>().add(GchatInitialEvent());
                            // context.read<GroupBloc>().add(GroupInitialEvent());
                            // context
                            //     .read<GroupFunctionalityBloc>()
                            //     .add(GroupFunctionalityInitialEvent());
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

  List<List> listdata = [
    ["assets/icons/User Icon.svg", "My Account"],
    ["assets/icons/Flash Icon.svg", "About us"],
    ["assets/icons/Bell.svg", "Notifications"],
    ["assets/icons/Lock.svg", "privacy"],
  ];
}
