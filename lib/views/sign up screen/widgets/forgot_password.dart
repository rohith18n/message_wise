import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_wise/components/custom_formfield.dart';
import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/components/text_row.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';

ValueNotifier<int> gg = ValueNotifier(1);

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final forgotFormkey = GlobalKey<FormState>();
    return Form(
        key: forgotFormkey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(20),
              horizontal: getProportionateScreenWidth(40)),
          child: Column(
            children: [
              Text("Reset Password", style: headingStyle),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
                hintText: "Enter your email",
                svgIcon: "assets/icons/Mail.svg",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is empty";
                  } else if (!EmailValidator.validate(value)) {
                    return "Enter a valid email";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
//bloclistner
//navigate if password reset
//snackbar on exception
              SizedBox(
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {},
                  child: DefaultButton(
                      press: () async {
                        if (forgotFormkey.currentState!.validate()) {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(ForgotPasswordEvent(
                            email: emailController.text,
                          ));
                        }
                      },
                      text: "confirm"),
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
