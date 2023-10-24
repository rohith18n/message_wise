import 'package:message_wise/Models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/size_config.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class GroupMessage extends StatelessWidget {
  const GroupMessage(
      {super.key,
      required this.message,
      required this.uID,
      required this.currentUsername});
  final GroupMsgModel message;
  final String uID;
  final String currentUsername;

  @override
  Widget build(BuildContext context) {
    // String date = message['time'] == null
    //     ? "time"
    //     : DateFormat.jm()
    //         .format((message['time'] as Timestamp).toDate())
    //         .toString();

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: Container(
          alignment: message.sendby == FirebaseAuth.instance.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.sendby == uID
                  ? colorMessageCurrentuser
                  : colorMessageClientuser,
            ),
            constraints: BoxConstraints(
              minWidth: getProportionateScreenWidth(40),
              minHeight: getProportionateScreenWidth(30),
              maxWidth: getProportionateScreenWidth(200),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenWidth(6),
              ),
              child: Column(
                children: [
                  message.sendby == uID
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: message.image == null
                                  ? const AssetImage(nullPhoto) as ImageProvider
                                  : NetworkImage(message.image ?? ""),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(5),
                            ),
                            CustomText(
                                content: message.username,
                                size: 15,
                                colour: Colors.deepOrangeAccent),
                          ],
                        ),
                  CustomText(
                    content: message.message,
                    size: 15,
                    colour: message.sendby == uID
                        ? colorMessageClientTextWhite
                        : colorMessageClientText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        content: DateFormat.jm()
                            .format(DateTime.parse(message.time)),
                        size: 11,
                        colour: message.sendby == uID
                            ? colorMessageClientTextWhite.withOpacity(0.5)
                            : colorMessageClientText.withOpacity(0.5),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
