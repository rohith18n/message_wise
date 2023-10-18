import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.userName,
      required this.imageUrl,
      required this.trailingWidget});
  final String userName;
  final Widget trailingWidget;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorWhite,
        radius: getProportionateScreenWidth(20),
        backgroundImage: NetworkImage(imageUrl),
      ),

      ///connection button
      trailing: trailingWidget,
      title: CustomText(
        content: userName,
        colour: kTextColor,
      ),
    );
  }
}

class CustomTileTrailing extends StatelessWidget {
  const CustomTileTrailing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: getProportionateScreenWidth(10),
          child: Center(
              child: CustomText(
            content: "1",
            colour: kTextColor,
            size: getProportionateScreenHeight(10),
          )),
        ),
        const CustomText(
          content: "5:11",
          colour: kTextColor,
        )
      ],
    );
  }
}
