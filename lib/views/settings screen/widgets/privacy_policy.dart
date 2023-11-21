import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(content: 'Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              content:
                  "Rohith N developed the Message Wise app as a free service. This service is provided by Rohith N at no cost and is intended for use as is. The purpose of this page is to inform visitors about my policies regarding the collection, use, and disclosure of personal information if they decide to use my service. "
                  "If you choose to use my service, you agree to the collection and use of information in accordance with this policy. The personal information that I collect is used for providing and improving the service. I will not use or share your information with anyone except as described in this privacy policy. "
                  "The terms used in this privacy policy have the same meanings as in our terms and conditions, which are accessible at Message Wise unless otherwise defined in this privacy policy. \n\n"
                  "Information Collection and Use: \n"
                  "For a better experience while using our service, I may require you to provide certain personally identifiable information, including but not limited to camera and storage access. The information I request will be retained on your device and is not collected by me in any way. The app uses third-party services that may collect information to identify you. Please refer to the privacy policy of third-party service providers used by the app. \n\n"
                  "Log Data: "
                  "Whenever you use my service and in the case of an error, I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device's IP address, device name, operating system version, the configuration of the app when using my service, the time and date of your use of the service, and other statistics. \n\n"
                  "Cookies: "
                  "This service does not use cookies explicitly. However, third-party code and libraries used by the app may use cookies to collect information and improve their services. You can choose to accept or refuse these cookies and know when a cookie is being sent to your device. \n\n"
                  "Service Providers: "
                  "I may employ third-party companies and individuals to facilitate our service, provide the service on our behalf, perform service-related services, or assist us in analyzing how our service is used. These third parties have access to your personal information only to perform tasks assigned to them on our behalf and are obligated not to disclose or use it for any other purpose. \n\n"
                  "Security: "
                  "I value your trust in providing us with your personal information, and I strive to use commercially acceptable means to protect it. However, no method of transmission over the internet or electronic storage is 100% secure, and I cannot guarantee absolute security. \n\n"
                  "Links to Other Sites: "
                  "This service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me, and I have no control over and assume no responsibility for their content, privacy policies, or practices. \n\n"
                  "Children's Privacy: "
                  "This service does not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. If I discover that a child under 13 has provided me with personal information, I immediately delete it from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I can take the necessary actions. \n\n"
                  "Changes to This Privacy Policy: "
                  "I may update our privacy policy from time to time. Therefore, it is advised to review this page periodically for any changes. I will notify you of any changes by posting the new privacy policy on this page. This policy is effective as of 2023-10-01. \n\n"
                  "Contact Us: "
                  "If you have any questions or suggestions about my privacy policy, do not hesitate to contact me at rohith18n@gmail.com. ",
              size: 16,
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Row(children: [
              const CustomText(content: 'for more info', size: 16),
              sizeWidth20,
              const CustomText(
                content: 'rohith18n@gmail.com',
                colour: kPrimaryColor,
                size: 16,
              )
            ])
          ],
        ),
      ),
    );
  }
}
