import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/custom_list_view.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/custom_request_button.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/search_field.dart';
import '../../../Controllers/chat bloc/chat_bloc.dart';
import '../../../Controllers/search bloc/search_bloc.dart';
import '../../../Controllers/users bloc/users_bloc.dart';
import '../../../Models/user_model.dart';
import '../../../util.dart';

import '../../individual chat screen/individual_chat_screen.dart';

class UsersListInContact extends StatefulWidget {
  const UsersListInContact(
      {super.key, required this.users, required this.iscontactScreen});
  final List<UserModels> users;
  final bool iscontactScreen;

  @override
  State<UsersListInContact> createState() => _UsersListInContactState();
}

class _UsersListInContactState extends State<UsersListInContact> {
  final _textEditingcontroller = TextEditingController();
  List<UserModels> result = [];
  @override
  void initState() {
    result = widget.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sizeHeight15,
        SearchField(
          textEditingcontroller: _textEditingcontroller,
          onChanged: (value) async {
            setState(() {
              result = widget.users
                  .where((element) => element.username!.contains(value))
                  .toList();
            });

            context.read<SearchBloc>().add(SearchingEvent(query: value));
          },
          hintText: "                  search user ",
        ),
        sizeHeight15,
//list view
        Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return BlocListener<ChatBloc, ChatState>(
                  listenWhen: (previous, current) =>
                      previous != current || previous == current,
                  listener: (context, state) {
                    if (state is ChatFirstState) {
                      log("entering to chat");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndividualChatScreen(
                              person: state.bot,
                              roomID: state.roomID,
                            ),
                          ));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      if (!widget.iscontactScreen) {
                        context
                            .read<ChatBloc>()
                            .add(EnterToChatEvent(bot: result[index]));
                      }
                    },
                    child: CustomListTile(
                      userName: result[index].username ?? "No Username",
                      imageUrl:
                          result[index].photo ?? "assets/images/nullPhoto.jpeg",
                      trailingWidget: widget.iscontactScreen
                          ? requestButton(index)
                          : const CustomTileTrailing(),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: result.length),
        ),
      ],
    );
  }

  Widget requestButton(int index) {
    if (result[index].state == UserConnections.request) {
      return CustomRowButtons(
        onPressedFirst: () {
          context
              .read<UsersBloc>()
              .add(DeclineRequestevent(botId: result[index].uid));
          setState(() {
            result[index].state = UserConnections.connect;
          });
        },
        onPressedSecond: () {
          context
              .read<UsersBloc>()
              .add(AcceptRequestEvent(botId: result[index].uid));
          setState(() {
            result[index].state = UserConnections.connected;
          });
        },
      );
    } else if (result[index].state == UserConnections.connected) {
      return CustomRequestButton(
        onPressed: () {},
        textContent: "connected",
        buttonStyle: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(successColor)),
        height: getProportionateScreenHeight(25),
      );
    } else if (result[index].state == UserConnections.connect) {
      return CustomRequestButton(
        height: getProportionateScreenHeight(25),
        onPressed: () {
          context
              .read<UsersBloc>()
              .add(SendRequestEvent(botId: result[index].uid));
          setState(() {
            result[index].state = UserConnections.pending;
          });
        },
        textContent: "request",
      );
    } else {
      return CustomRequestButton(
        onPressed: () {
          if (result[index].state == UserConnections.pending) {
            context
                .read<UsersBloc>()
                .add(RemoveRequestEvent(botId: result[index].uid));
            setState(() {
              result[index].state = UserConnections.connect;
            });
          }
        },
        textContent: "Pending",
      );
    }
  }
}
