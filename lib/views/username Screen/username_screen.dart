import 'package:message_wise/components/custom_surfix_icon.dart';
import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';

class UsernameScreen extends StatelessWidget {
  static String routeName = "/usernamescreen";
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Message Wise",
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(36),
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text("welcome", style: headingStyle),
                  sizeHeight15,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: TextField(
                      controller: userNameController,
                      style: GoogleFonts.poppins(color: colorblack),
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter username",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: CustomSurffixIcon(
                            svgIcon: "assets/icons/User Icon.svg"),
                      ),
                    ),
                  ),
                  sizeHeight15,
                  SizedBox(
                    width: 300,
                    child: DefaultButton(
                      press: () {
                        if (userNameController.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"userName": userNameController.text});
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, (route) => false);
                        }
                      },
                      text: "continue",
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
