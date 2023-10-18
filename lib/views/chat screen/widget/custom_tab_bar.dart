import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, this.onTap});
  final Function(int)? onTap;
  @override
  Widget build(BuildContext context) {
    return TabBar(
        onTap: onTap,
        unselectedLabelColor: kTextColor,
        isScrollable: true,
        labelColor: colorblack,
        labelPadding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(60)),
        indicatorColor: kPrimaryColor,
        tabs: const [
          Tab(child: CustomText(content: "Friends")),
          Tab(
            child: CustomText(content: "Groups"),
          ),
        ]);
  }
}
