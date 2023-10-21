import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';
import 'package:message_wise/constants.dart';

import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              CustomText(
                size: getProportionateScreenWidth(20),
                content: "We sent an otp to your Phone",
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return const OtpForm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
