// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import '../../../Models/select_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../new_group_screen.dart';

class GroupMembersIcon extends StatelessWidget {
  GroupMembersIcon({super.key, required this.bot, this.isVisible = true});
  final SelectModel bot;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
              minWidth: getProportionateScreenWidth(80),
              minHeight: getProportionateScreenHeight(50)),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: bot.bot.photo == null
                    ? const AssetImage("assets/images/nullPhoto.jpeg")
                        as ImageProvider
                    : NetworkImage(bot.bot.photo ?? ""),
              ),
              Container(
                  constraints: BoxConstraints(
                      maxWidth: getProportionateScreenWidth(60),
                      maxHeight: getProportionateScreenHeight(20)),
                  child: CustomText(
                    content: bot.bot.username ?? "",
                    colour: kTextColor,
                    size: getProportionateScreenHeight(10),
                  ))
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Positioned(
              top: -18,
              left: 30,
              child: IconButton(
                  onPressed: () {
                    bot.isselected = false;
                    selectedBots.value.removeWhere(
                        (element) => element.bot.uid == bot.bot.uid);
                    selectedBots.notifyListeners();
                    if (selectedBots.value.isEmpty) {
                      isVisibleNavigation.value = false;
                      isVisibleNavigation.notifyListeners();
                    }
                  },
                  icon: const Icon(
                    Icons.close,
                    color: closeIconColor,
                    size: 15,
                  ))),
        )
      ],
    );
  }
}
