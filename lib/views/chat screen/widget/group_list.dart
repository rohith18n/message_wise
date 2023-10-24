import 'package:message_wise/Controllers/gchat%20bloc/gchat_bloc.dart';
import 'package:message_wise/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:message_wise/Controllers/group%20functionality/group_functionality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/new%20chat%20screen/widgets/search_field.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../group chat screen/group_chat_screen.dart';

class GroupList extends StatelessWidget {
  GroupList({super.key});

  final _textEditingcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBloc>().add(FetchGroupsEvent());
    });

    return Column(
      children: [
        sizeHeight15,
        SearchField(
          textEditingcontroller: _textEditingcontroller,
          onChanged: (value) async {},
          hintText: "                  search user",
        ),
//list view
        Expanded(
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is GroupListState) {
                return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BlocListener<GroupBloc, GroupState>(
                        listener: (context, state) {
                          if (state is GroupListState) {}
                        },
                        child: InkWell(
                          onTap: () {
                            context.read<GchatBloc>().add(FetchMessageEvent(
                                groupId: state.groups[index].groupId));
                            context.read<GroupFunctionalityBloc>().add(
                                FetchMembersEvent(
                                    groupId: state.groups[index].groupId));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupChatScreen(
                                          groupData: state.groups[index],
                                        )));
                          },
                          child: ListTile(
                            subtitle: Container(
                              constraints: const BoxConstraints(maxWidth: 170),
                              width: getProportionateScreenWidth(170),
                              height: getProportionateScreenHeight(13),
                              child: CustomText(
                                content:
                                    "${state.groups[index].sendby} : ${state.groups[index].lastMsg ?? ""}",
                                colour: kTextColor,
                                size: getProportionateScreenHeight(10),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: colorWhite,
                              radius: getProportionateScreenHeight(20),
                              backgroundImage: state.groups[index].photo == null
                                  ? const AssetImage(nullPhoto) as ImageProvider
                                  : NetworkImage(
                                      state.groups[index].photo ?? ""),
                            ),

                            ///connection button

                            title: CustomText(
                              content: state.groups[index].name,
                              colour: kTextColor,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.groups.length);
              } else {
                return const CustomIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
