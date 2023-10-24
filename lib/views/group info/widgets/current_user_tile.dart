//current user tile =========================================================================================================================
import 'package:flutter/material.dart';
import 'package:message_wise/size_config.dart';
import '../../../Models/group_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class CurrentUserTile extends StatelessWidget {
  const CurrentUserTile({super.key, required this.currentUser});
  final GroupMember currentUser;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: currentUser.photo == null
            ? const AssetImage(nullPhoto) as ImageProvider
            : NetworkImage(currentUser.photo ?? ""),
      ),
      title: const CustomText(content: "you"),
      trailing: currentUser.isAdmin ? adminTag() : const SizedBox.shrink(),
    );
  }
}

// admin Tag
Container adminTag() {
  return Container(
    padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(4),
        horizontal: getProportionateScreenWidth(8)),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: colorMessageClientTextWhite),
    child: CustomText(
      content: "Admin",
      size: getProportionateScreenHeight(8),
    ),
  );
}

List<PopupMenuItem<String>> get adminPermissionAd {
  return [
    const PopupMenuItem(
      value: "removeAdmin",
      child: Text("Dismiss as Admin"),
    ),
    const PopupMenuItem(
      value: "remove",
      child: Text("Remove"),
    ),
  ];
}

List<PopupMenuItem<String>> get adminPermission {
  return [
    const PopupMenuItem(
      value: "admin",
      child: Text("Make Group Admin "),
    ),
    const PopupMenuItem(
      value: "remove",
      child: Text("Remove"),
    ),
  ];
}
