import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';

import 'package:message_wise/components/socal_card.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';

class SocalCardRow extends StatelessWidget {
  const SocalCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SocalCard(
              icon: "assets/icons/google-icon.svg",
              press: () {
                context.read<AuthenticationBloc>().add(GoogleSignInEvent());
              },
            ),
            CustomText(
              size: getProportionateScreenWidth(12),
              content: "Sign in with \n    Google",
              colour: colorblack,
            ),
          ],
        ),
        // SizedBox(
        //   width: getProportionateScreenWidth(20),
        // ),
        // Column(
        //   children: [
        //     SocalCard(
        //       icon: "assets/icons/Phone.svg",
        //       press: () {
        //         context.read<AuthenticationBloc>().add(PhoneSignInEvent());
        //       },
        //     ),
        //     CustomText(
        //       size: getProportionateScreenWidth(12),
        //       content: "Sign in with \n    Phone",
        //       colour: colorblack,
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
