import 'dart:developer';
import 'package:message_wise/components/custom_formfield.dart';
import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/components/text_row.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/authentication_screen/widgets/verify_email_button.dart';
import 'package:message_wise/views/username%20Screen/username_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _signFormkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _signFormkey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(20),
              horizontal: getProportionateScreenWidth(40)),
          child: Column(
            children: [
              Text("Create New Account", style: headingStyle),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                controller: _emailController,
                labelText: "Email",
                hintText: "Enter your Email",
                svgIcon: "assets/icons/Mail.svg",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is empty";
                  } else if (!EmailValidator.validate(value)) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "Enter your password",
                svgIcon: "assets/icons/Lock.svg",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password is empty";
                  } else if (value.length <= 7) {
                    return "password must contain at least 8 characters";
                  } else {
                    return null;
                  }
                },
                obscureText: true,
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                hintText: "Confirm your password",
                svgIcon: "assets/icons/Lock.svg",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password is empty";
                  } else if (value.length <= 7) {
                    return "password must contain at least 8 characters";
                  } else if (value != _passwordController.text) {
                    return "passwords do not match";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is UsernameState) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsernameScreen(),
                        ),
                        (route) => false);
                  } else if (state is ValidationErrorState) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(
                        message: state.exceptionOnLogin,
                      ),
                    );
                  } else if (state is EmailVerificationState) {
                    log("emailverificationstate${state.isVerified}");
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        child: StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return const VerifyEmailButton();
                              } else {
                                return DefaultButton(
                                    press: () async {
                                      if (_signFormkey.currentState!
                                          .validate()) {
                                        BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .add(SignUpEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ));
                                      }
                                    },
                                    text: "Sign Up");
                              }
                            }),
                      ),
                      if (state is EmailVerificationState)
                        const CustomText(
                          content: "please check your email",
                          colour: colorblack,
                        ),
                    ],
                  );
                },
              ),
              TextRow(
                firstText: "Already have an account?",
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
