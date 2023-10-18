import 'package:message_wise/Models/user_model.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/util.dart';
import 'package:flutter/material.dart';
import '../common/widgets/custom_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});
  final UserModels user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(user.photo ?? "22"),
                ),
                sizeHeight15,
                CustomText(
                  content: user.username ?? "",
                  size: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {},
                          icon: const Icon(
                            Icons.call_outlined,
                            color: iconColorGreen,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.video_call,
                            color: iconColorGreen,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: iconColorGreen,
                            size: 30,
                          )),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    const CustomText(
                      content: "info : ",
                      colour: kTextColor,
                      size: 15,
                    ),
                    CustomText(
                      content: user.email,
                      colour: kTextColor,
                      size: 15,
                    ),
                  ],
                ),
                sizeHeight15,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    const CustomText(
                      content: "username : ",
                      colour: kTextColor,
                      size: 15,
                    ),
                    CustomText(
                      content: user.username ?? "",
                      colour: kTextColor,
                      size: 15,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    sizeWidth20,
                    const CustomText(
                      content: "clear chat",
                      colour: errorColor,
                    ),
                  ],
                ),
                sizeHeight15,
                Row(
                  children: [
                    sizeWidth20,
                    const CustomText(
                      content: "block",
                      colour: errorColor,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    const CustomText(
                      content: "group in common",
                      colour: kTextColor,
                      size: 15,
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
