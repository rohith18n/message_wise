import 'package:flutter/services.dart';
import 'package:message_wise/Controllers/authentication/authentication_bloc.dart';
import 'package:message_wise/Controllers/bloc/status_bloc.dart';
import 'package:message_wise/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:message_wise/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:message_wise/Controllers/profile/profile_bloc_bloc.dart';
import 'package:message_wise/Controllers/search%20bloc/search_bloc.dart';
import 'package:message_wise/injectable.dart';
import 'package:message_wise/routes.dart';
import 'package:message_wise/theme.dart';
import 'package:message_wise/views/splash%20Screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Controllers/gchat bloc/gchat_bloc.dart';
import 'Controllers/group functionality/group_functionality_bloc.dart';
import 'Controllers/users bloc/users_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
      ),
    );
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(),
          ),
          BlocProvider(
            create: (context) => SearchBloc(),
          ),
          BlocProvider(
            create: (context) => ChatBloc(),
          ),
          BlocProvider(
            create: (context) => StatusBloc(),
          ),
          BlocProvider(
            create: (context) => getIt<ProfileBlocBloc>(),
          ),
          BlocProvider(create: (context) => UsersBloc()),
          BlocProvider(create: (context) => GroupBloc()),
          BlocProvider(lazy: true, create: (context) => getIt<GchatBloc>()),
          BlocProvider(
              lazy: true, create: (context) => getIt<GroupFunctionalityBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Message_Wise',
          theme: AppTheme.lightTheme(context),
          initialRoute: SplashScreen.routeName,
          routes: routes,
        ));
  }
}
