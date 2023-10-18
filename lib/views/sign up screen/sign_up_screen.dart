import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:message_wise/views/sign%20up%20screen/widgets/forgot_password.dart';
import 'package:message_wise/views/sign%20up%20screen/widgets/login_form.dart';
import 'package:message_wise/views/sign%20up%20screen/widgets/signup_form.dart';
import 'package:message_wise/views/sign%20up%20screen/widgets/socal_card_row.dart';
import 'package:message_wise/views/username%20Screen/username_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Controllers/authentication/authentication_bloc.dart';
import '../../util.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/authentication";
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(50)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    content: "Message Wise",
                    size: getProportionateScreenWidth(36),
                    colour: kPrimaryColor,
                    weight: FontWeight.bold,
                  ),

                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is LoginState) {
                        return const LoginForm();
                      } else if (state is SignUpState) {
                        return const SignUpForm();
                      } else if (state is LoadForgotPassowrdState) {
                        return const ForgotPassword();
                      }
                      //  else if (state is PhoneSignInState) {
                      //   return const PhoneLogin();
                      // }
                      else {
                        return const LoginForm();
                      }
                    },
                  ),
                  //google Sign in
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        //if the user is signing up, will navigate to the username screen
                        //will emit usernamestate
                        if (state is UsernameState) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              UsernameScreen.routeName, (route) => false);
                        }
                        //it will show at the loading time

                        else if (state is LoadingState) {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                              message: state.isLoading ? "loading" : "success",
                            ),
                          );
                        }
                        //if user is signed already, will navigate to HomeScreen
                        //emit bloc signed state
                        else if (state is SignedState) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, (route) => false);
                        } else if (state is ValidationErrorState) {
                          showTopNotification(
                              color: Colors.red,
                              context: context,
                              state: state.exceptionOnLogin);
                        } else if (state is ResetPasswordSuccessState) {
                          showTopNotification(
                              color: Colors.green,
                              context: context,
                              state:
                                  "A reset link has been sent to your email");
                        }
                        // else if (state is PhoneSignInLoadedState) {
                        //   Navigator.of(context).pushNamed(HomeScreen.routeName);
                        // } else if (state is PhoneSignInErrorState) {
                        //   showTopNotification(
                        //       color: Colors.red,
                        //       context: context,
                        //       state: state.error);
                        // } else if (state is PhoneAuthCodeSentSuccessState) {
                        //   Navigator.of(context).pushNamed(OtpScreen.routeName);
                        // }
                      },
                      child: const SocalCardRow()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
