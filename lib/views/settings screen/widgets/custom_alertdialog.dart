import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_wise/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionName;
  final VoidCallback? press;
  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.actionName,
    this.press,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: outlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      title: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.poppins(
            color: Colors.black.withOpacity(0.7), fontSize: 14),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: kTextColor, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: press,
              child: Text(
                actionName,
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
