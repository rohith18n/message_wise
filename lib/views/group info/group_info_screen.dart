// ignore_for_file: unnecessary_null_comparison

import 'package:message_wise/Models/group_model.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/group%20info/widgets/group_settings.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Controllers/group functionality/group_functionality_bloc.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';
import 'functions/group_members_sheet.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class GrpupInfoScreen extends StatelessWidget {
  const GrpupInfoScreen({Key? key, required this.groupInfo}) : super(key: key);
  final GroupModel groupInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const CustomText(
          content: "Group Info",
          colour: kTextColor,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenHeight(20),
          ),
          child: Column(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(200),
                height: getProportionateScreenHeight(200),
                child: CircleAvatar(
                  backgroundImage: groupInfo.photo == null
                      ? const AssetImage(nullPhoto) as ImageProvider<Object>
                      : NetworkImage(groupInfo.photo!),
                ),
              ),
              sizeHeight15,
              CustomText(
                content: groupInfo.name, // Handle possible null
                colour: kTextColor,
              ),
              sizeHeight15,
              //membres
              Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(300),
                    child: ListTile(
                      onTap: () async {
                        if (groupInfo.groupId != null &&
                            groupInfo.name != null) {
                          await showMembers(
                              context, groupInfo.groupId, groupInfo.name);
                        }
                      },
                      leading: const Icon(
                        Icons.group,
                        color: kTextColor,
                      ),
                      title: const CustomText(
                        content: "Members",
                        colour: kTextColor,
                      ),
                    ),
                  )
                ],
              ),
              // group settings
              BlocBuilder<GroupFunctionalityBloc, GroupFunctionalityState>(
                builder: (context, state) {
                  if (state is MembersLoadedState) {
                    if (!state.isloading) {
                      if (state.currentUser != null &&
                          state.currentUser!.isAdmin) {
                        return GroupSettings(
                          groupId: groupInfo.groupId, // Handle possible null
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              // exit group
              BlocConsumer<GroupFunctionalityBloc, GroupFunctionalityState>(
                listener: (context, state) {
                  if (state is ExitedGroup || state is DismissState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeScreen.routeName,
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MembersLoadedState) {
                    if (state.currentUser != null) {
                      if (state.currentUser!.isOwner) {
                        return exitGroup(context: context, isExitGroup: false);
                      } else {
                        return exitGroup(context: context, isExitGroup: true);
                      }
                    }
                  }
                  return exitGroup(context: context, isExitGroup: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row exitGroup({required BuildContext context, required bool isExitGroup}) {
    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(300),
          child: ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      getProportionateScreenHeight(10),
                    ),
                  ),
                  title: isExitGroup
                      ? const Text('Exit Group')
                      : const Text('Dismiss Group'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        isExitGroup
                            ? const Text('Confirm Exit?')
                            : const Text('Confirm Dismiss?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the AlertDialog
                        Future.delayed(Duration.zero, () {
                          if (isExitGroup) {
                            context.read<GroupFunctionalityBloc>().add(
                                  ExitGroup(
                                    groupId: groupInfo
                                        .groupId, // Handle possible null
                                  ),
                                );
                          } else {
                            context.read<GroupFunctionalityBloc>().add(
                                  DismissGroup(
                                    groupId: groupInfo
                                        .groupId, // Handle possible null
                                  ),
                                );
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: errorColor,
            ),
            title: CustomText(
              content: isExitGroup ? "Exit Group" : "Dismiss Group",
              colour: errorColor,
            ),
          ),
        )
      ],
    );
  }
}
