import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';
import 'package:message_wise/components/custom_formfield.dart';
import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/components/text_row.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/otp_screen/otp_screen.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final RegExp phoneNumberRegex = RegExp(r'^\+91[0-9]{10}$');
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final phoneFormkey = GlobalKey<FormState>();
    return Form(
        key: phoneFormkey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(20),
              horizontal: getProportionateScreenWidth(40)),
          child: Column(
            children: [
              Text("Enter Phone Number", style: headingStyle),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                labelText: "Phone",
                hintText: "Enter your Phone",
                svgIcon: "assets/icons/Phone.svg",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is empty";
                  }
                  if (!phoneNumberRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  } else {
                    return null;
                  }
                },
              ),
              sizeHeight15,
//bloclistner
//snackbar on exception
              SizedBox(
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state is PhoneAuthCodeSentSuccessState) {
                      showTopNotification(
                          color: Colors.green,
                          context: context,
                          state: "Otp sent successfully");
                      Navigator.of(context).pushNamed(OtpScreen.routeName);
                      // BlocProvider.of<AuthenticationBloc>(context).add(OnPhoneOtpSentEvent(verificationId: state.verificationId));
                    }
                  },
                  child: DefaultButton(
                      press: () async {
                        if (phoneFormkey.currentState!.validate()) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              SendOtpToPhoneEvent(
                                  phoneNumber: _phoneController.text));
                        }
                      },
                      text: "continue"),
                ),
              ),
              TextRow(
                firstText: "Go back to login page",
                secondText: "Login",
                press: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LoadLoginScreenEvent());
                },
              ),
            ],
          ),
        ));
  }
}
