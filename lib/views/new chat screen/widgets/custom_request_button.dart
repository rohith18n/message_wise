import 'package:flutter/material.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class CustomRequestButton extends StatelessWidget {
  const CustomRequestButton(
      {super.key,
      required this.onPressed,
      required this.textContent,
      this.height,
      this.buttonStyle});
  final String textContent;
  final void Function() onPressed;
  final double? height;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: CustomText(
            content: textContent,
            size: 10,
          )),
    );
  }
}

class CustomRowButtons extends StatelessWidget {
  final Function() onPressedFirst;
  final Function() onPressedSecond;
  const CustomRowButtons(
      {super.key, required this.onPressedFirst, required this.onPressedSecond});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: getProportionateScreenWidth(30),
          child: IconButton(
              icon: const Icon(
                Icons.close,
                color: errorColor,
              ),
              onPressed: onPressedFirst),
        ),
        SizedBox(
          width: getProportionateScreenWidth(30),
          child: IconButton(
              icon: const Icon(
                Icons.check,
                color: successColor,
              ),
              onPressed: onPressedSecond),
        ),
      ],
    );
  }
}
