import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const CustomText(content: 'About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(80),
            ),
            Text(
              'Message Wise',
              style: appBarHeadingStyle,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Message Wise ',
                      style: TextStyle(fontSize: 18, color: kPrimaryColor),
                    ),
                    TextSpan(
                        text:
                            " Message Wise is a social media application designed for various functionalities such as posting images, personal chatting, group chatting, adding status updates, and more. Users can engage in conversations with their connections, share images, and post status updates that are visible to everyone logged into the platform.",
                        style: TextStyle(fontSize: 18, color: kTextColor)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomText(
                content: 'Version 1. 2. 0',
                size: getProportionateScreenHeight(14),
                colour: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomText(
                content: 'Created by Rohith N',
                size: getProportionateScreenHeight(18),
                colour: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
