import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class TextRow extends StatelessWidget {
  const TextRow({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.press,
  }) : super(key: key);

  final String firstText;
  final String secondText;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstText,
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        TextButton(
          onPressed: press,
          child: Text(
            secondText,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
