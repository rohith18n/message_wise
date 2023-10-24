import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/size_config.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message, required this.uID});
  final QueryDocumentSnapshot<Map<String, dynamic>> message;
  final String uID;

  @override
  Widget build(BuildContext context) {
    String date = message['time'] == null
        ? "time"
        : DateFormat.jm()
            .format((message['time'] as Timestamp).toDate())
            .toString();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(10)),
      child: Container(
          alignment: message['sendby'] == uID
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message['sendby'] == uID
                  ? colorMessageCurrentuser
                  : colorMessageClientuser,
            ),
            constraints: BoxConstraints(
              minWidth: getProportionateScreenWidth(80),
              maxWidth: getProportionateScreenWidth(200),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              child: Column(
                children: [
                  CustomText(
                    content: message["message"],
                    size: 15,
                    colour: message['sendby'] == uID
                        ? colorMessageClientTextWhite
                        : colorMessageClientText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        content: date,
                        size: 11,
                        colour: message['sendby'] == uID
                            ? colorMessageClientTextWhite.withOpacity(0.5)
                            : colorMessageClientText.withOpacity(0.5),
                      ),
                      message['sendby'] == uID
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.done_all,
                              color: colorMessageClientText,
                              size: 15,
                            )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
