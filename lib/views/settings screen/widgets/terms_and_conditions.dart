import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              content:
                  "By downloading or using the app, you automatically agree to be bound by these terms, so it's essential to read them carefully before using the application. Unauthorized copying or modification of the app, its components, or our trademarks is strictly prohibited. Attempting to extract the app's source code or translating it into other languages or creating derivative versions is also not permitted. The app, along with all trademarks, copyrights, database rights, and other intellectual property rights associated with it, remains the property of Rohith N. "
                  "We are committed to ensuring the app's usefulness and efficiency. Therefore, we reserve the right to make changes to the app or introduce charges for its services at any time and for any reason. Rest assured, we will communicate any charges clearly before you incur them."
                  "Message Wise stores and processes personal data you provide to us in order to deliver our services. It is your responsibility to maintain the security of your phone and access to the app. We strongly advise against jailbreaking or rooting your phone, as this could expose your device to malware, compromise security features, and potentially render the Message Wise app dysfunctional."
                  "Additionally, the app utilizes third-party services, each governed by their respective Terms and Conditions.",
              size: 16,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Row(children: [
              const CustomText(
                content: 'For more :',
                size: 16,
              ),
              sizeWidth20,
              const CustomText(
                content: 'rohith18n@gmail.com',
                size: 16,
                colour: kPrimaryColor,
              )
            ])
          ],
        ),
      ),
    );
  }
}
