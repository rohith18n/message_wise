import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';

import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:message_wise/views/otp_screen/components/custom_otp_field.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  OtpFormState createState() => OtpFormState();
}

class OtpFormState extends State<OtpForm> {
  final _otpController1 = TextEditingController();
  final _otpController2 = TextEditingController();
  final _otpController3 = TextEditingController();
  final _otpController4 = TextEditingController();
  final _otpController5 = TextEditingController();
  final _otpController6 = TextEditingController();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.05),
            CustomText(
              size: getProportionateScreenWidth(18),
              content: "Enter your otp",
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOtpField(
                  controller: _otpController1,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
                CustomOtpField(
                  controller: _otpController2,
                  focusNode: pin2FocusNode,
                  onChanged: (value) {
                    nextField(value, pin3FocusNode);
                  },
                ),
                CustomOtpField(
                  controller: _otpController3,
                  focusNode: pin3FocusNode,
                  onChanged: (value) {
                    nextField(value, pin4FocusNode);
                  },
                ),
                CustomOtpField(
                  controller: _otpController4,
                  focusNode: pin4FocusNode,
                  onChanged: (value) {
                    nextField(value, pin5FocusNode);
                  },
                ),
                CustomOtpField(
                  controller: _otpController5,
                  focusNode: pin5FocusNode,
                  onChanged: (value) {
                    nextField(value, pin6FocusNode);
                  },
                ),
                CustomOtpField(
                    controller: _otpController6,
                    focusNode: pin6FocusNode,
                    onChanged: (value) {
                      if (value.length == 1) {
                        pin6FocusNode!.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                    }),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.2),
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is PhoneSignInLoadedState) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (route) => false);
                } else if (state is PhoneSignInErrorState) {
                  showTopNotification(
                      color: Colors.red, context: context, state: state.error);
                }
              },
              child: DefaultButton(
                text: "Continue",
                press: () async {
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      if (state is PhoneAuthCodeSentSuccessState) {
                        String otpCode = _otpController1.text.trim() +
                            _otpController2.text.trim() +
                            _otpController3.text.trim() +
                            _otpController4.text.trim() +
                            _otpController5.text.trim() +
                            _otpController6.text.trim();

                        BlocProvider.of<AuthenticationBloc>(context).add(
                            VerifySentOtpEvent(
                                otpCode: otpCode,
                                verificationId: state.verificationId));
                      }
                      if (state is PhoneSignInLoadedState) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
