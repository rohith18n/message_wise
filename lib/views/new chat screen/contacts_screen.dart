import 'dart:developer';
import 'package:message_wise/Models/user_model.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Controllers/users bloc/users_bloc.dart';
import '../../util.dart';

ValueNotifier<int> requestCount = ValueNotifier(0);

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  final List<UserModels> users = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersBloc>().add(const UsersListEvent());
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
            child: Text(
              "All Users",
              style: appBarHeadingStyle,
            ),
          ),
          bottom: TabBar(
              unselectedLabelColor: kTextColor,
              isScrollable: true,
              labelColor: colorblack,
              labelPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(60)),
              indicatorColor: kPrimaryColor,
              tabs: [
                const Tab(child: CustomText(content: "All Users")),
                Tab(
                  child: Row(
                    children: [
                      const CustomText(content: "Requests"),
                      ValueListenableBuilder(
                        valueListenable: requestCount,
                        builder: (context, value, child) => value == 0
                            ? const SizedBox.shrink()
                            : Container(
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CustomText(
                                    content: value.toString(),
                                    size: 10,
                                    colour: colorMessageClientTextWhite,
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ]),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(10)),
            //stream builder
            //listen users collecion firestore
            child:
                BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
              log(" state is ${state.toString()}");
            }, builder: (context, state) {
              final List<UserModels> requestedUsers = [];
              if (state is OtherUsers) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  for (var bot in state.bots) {
                    if (bot.state == UserConnections.request) {
                      requestedUsers.add(bot);
                    }
                  }
                });

                requestCount.value = requestedUsers.length;
                return TabBarView(
                  children: [
                    UsersListInContact(
                      users: state.bots,
                      iscontactScreen: true,
                    ),
                    UsersListInContact(
                      users: requestedUsers,
                      iscontactScreen: true,
                    ),
                  ],
                );
              } else {
                return const TabBarView(children: [
                  Center(child: Text("no data")),
                  Center(child: Text("no data")),
                ]);
              }
            }),
          ),
        ),
      ),
    );
  }
}
