import 'dart:developer';
import 'package:message_wise/service/authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserCredential? user;
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoadLoginScreenEvent>((event, emit) {
      emit(LoginState());
    });
    on<LoadSignUpScreenEvent>((event, emit) {
      emit(SignUpState());
    });

    on<PhoneSignInEvent>((event, emit) {
      emit(const PhoneSignInState());
    });

    on<SignUpEvent>((event, emit) async {
      dynamic isSigned = await AuthService.signin(
          email: event.email, password: event.password);
      log("sign in check");
      String? sendVerificationEmailError =
          await AuthService.sendVerificationEmail();
      if (isSigned is UserCredential) {
        user = isSigned;
        //emit(SignedState(isSigned: isSigned));
      } else {
        add(LoadSignUpScreenEvent());
        emit(ValidationErrorState(exceptionOnLogin: isSigned));
      }
      if (sendVerificationEmailError != null) {
        add(LoadSignUpScreenEvent());
        emit(
            ValidationErrorState(exceptionOnLogin: sendVerificationEmailError));
      }
    });
    //check verified or not
    //after trigger this event
    on<VerifiedUserEvent>((event, emit) {
      // add to database(realtime database)

      FirebaseFirestore firestire = FirebaseFirestore.instance;
      if (user!.additionalUserInfo!.isNewUser == true) {
        firestire.collection("users").doc(user!.user?.uid).set({
          "userId": user?.user?.uid,
          "photo": user!.additionalUserInfo!.profile!['picture'],
          "email": user!.user!.email
        });
        log("new user");
        emit(const UsernameState());
      }
      //=================================
      log("verified event");
    });

    //login
    on<LoginEvent>((event, emit) async {
      dynamic isLogged = await AuthService.logIn(
        email: event.email,
        password: event.password,
      );

      log("log1");
      if (isLogged is bool) {
        log("log2");
        emit(LoggedState(isLogged: isLogged));
      } else {
        add(LoadLoginScreenEvent());
        emit(ValidationErrorState(exceptionOnLogin: isLogged));
      }
    });
    on<GoogleSignInEvent>((event, emit) async {
      emit(LoadingState(isLoading: true));
      final result = await AuthService.googleSignIn();
      if (result is UserCredential) {
        emit(LoadingState(isLoading: false));
        // add(LoadSignUpScreenEvent());
        if (result.additionalUserInfo!.isNewUser) {
          emit(const UsernameState());
        } else {
          emit(SignedState(isSigned: result));
        }

        log("google event");
      } else {
        emit(ValidationErrorState(exceptionOnLogin: result));
      }
    });
    //load forgott screeen
    on<LoadingForgotPasswordScreen>(
        (event, emit) => emit(LoadForgotPassowrdState()));
    //Forgot password event
    on<ForgotPasswordEvent>((event, emit) async {
      final result = await AuthService.forgotpassword(event.email);

      if (result != null) {
        log("hhhhhhhhhhhhhhh");
        emit(ValidationErrorState(exceptionOnLogin: result));
      } else {
        emit(ResetPasswordSuccessState());
        add(LoadLoginScreenEvent());
      }
    });

    //Initial event
    on<AuthenticationInitialEvent>(
        (event, emit) => emit(AuthenticationInitial()));

    on<SendOtpToPhoneEvent>((event, emit) async {
      emit(LoadingState(isLoading: true));
      try {
        await AuthService.logInWithPhone(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              add(OnPhoneAuthVerificationCompletedEvent(
                  //when entered otp is correct
                  credential: credential));
            },
            verificationFailed: (FirebaseAuthException error) {
              add(OnPhoneAuthErrorEvent(error: error.toString()));
            },
            codeSent: (String verificationId, int? refreshtoken) {
              add(OnPhoneOtpSentEvent(
                  //captcha verification
                  verificationId: verificationId,
                  token: refreshtoken));
            },
            codeAutoRetrivalTimeOut: (String verificationId) {});
      } catch (e) {
        emit(PhoneSignInErrorState(error: e.toString()));
      }
    });
    on<OnPhoneOtpSentEvent>((event, emit) {
      emit(PhoneAuthCodeSentSuccessState(verificationId: event.verificationId));
    });

    on<VerifySentOtpEvent>((event, emit) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.otpCode);
        add(OnPhoneAuthVerificationCompletedEvent(credential: credential));
      } catch (e) {
        emit(PhoneSignInErrorState(error: e.toString()));
      }
    });

    on<OnPhoneAuthErrorEvent>((event, emit) {
      emit(PhoneSignInErrorState(error: event.error.toString()));
    });

    on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        await FirebaseAuth.instance
            .signInWithCredential(event.credential)
            .then((value) {
          emit(SignUpScreenOtpSuccessState());
          emit(PhoneSignInLoadedState());
        });
      } catch (e) {
        emit(PhoneSignInErrorState(error: e.toString()));
      }
    });
  }
}
