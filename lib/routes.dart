import 'package:flutter/widgets.dart';

import 'package:message_wise/views/home%20Screen/home_screen.dart';

import 'package:message_wise/views/onBoard%20Screen/onboard_screen.dart';

import 'package:message_wise/views/settings%20screen/settings_screen.dart';
import 'package:message_wise/views/sign%20up%20screen/sign_up_screen.dart';
import 'package:message_wise/views/splash%20Screen/splash_screen.dart';

import 'package:message_wise/views/username%20Screen/username_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  // OtpScreen.routeName: (context) => const OtpScreen(),
  OnBoardScreen.routeName: (context) => const OnBoardScreen(),
  // UsernameScreen.routeName: (context) => const UsernameScreen(),
  // SettingsScreen.routeName: (context) => const SettingsScreen(),
};
