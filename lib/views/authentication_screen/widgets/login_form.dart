import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';
import 'package:message_wise/components/custom_formfield.dart';
import 'package:message_wise/components/default_button.dart';
import 'package:message_wise/components/text_row.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../common/widgets/custom_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormkey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(20),
              horizontal: getProportionateScreenHeight(40)),
          child: Column(
            children: [
              Text("Sign In", style: headingStyle),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                keyboardType: TextInputType.emailAddress,
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
              ),

              SizedBox(height: getProportionateScreenHeight(30)),
              CustomFormField(
                obscureText: true,
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
              ),

              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(LoadingForgotPasswordScreen());
                      },
                      child: CustomText(
                        content: "forgot password?",
                        size: getProportionateScreenWidth(16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
//bloc listner
//navigate user if login success
//snack bar on exception
              SizedBox(
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state is LoggedState) {
                      if (state.isLogged) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false);
                      }
                    } else if (state is ValidationErrorState) {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          backgroundColor: Colors.red,
                          message: state.exceptionOnLogin,
                        ),
                      );
                    }
                  },
                  child: DefaultButton(
                    text: "Continue",
                    press: () async {
                      if (_loginFormkey.currentState!.validate()) {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoginEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ));
                      }
                    },
                  ),
                ),
              ),
              TextRow(
                firstText: "Don't have an account?",
                secondText: "SignUp",
                press: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LoadSignUpScreenEvent());
                },
              ),
            ],
          ),
        ));
  }
}
