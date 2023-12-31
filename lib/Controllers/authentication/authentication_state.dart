// ignore_for_file: must_be_immutable

part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginState extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SignUpState extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoggedState extends AuthenticationState {
  final bool isLogged;

  const LoggedState({required this.isLogged});
  @override
  List<Object?> get props => [];
}

class SignedState extends AuthenticationState {
  final UserCredential isSigned;

  const SignedState({required this.isSigned});
  @override
  List<Object?> get props => [];
}

class EmailVerificationState extends AuthenticationState {
  bool isVerified;

  EmailVerificationState({required this.isVerified});
  @override
  List<Object?> get props => [];
}

class ValidationErrorState extends AuthenticationState {
  final String exceptionOnLogin;

  const ValidationErrorState({required this.exceptionOnLogin});
  @override
  List<Object?> get props => [];
}

class LoadingState extends AuthenticationState {
  bool isLoading = false;
  LoadingState({required this.isLoading});
  @override
  List<Object?> get props => [];
}

class UsernameState extends AuthenticationState {
  const UsernameState();
  @override
  List<Object?> get props => [];
}

class LoadForgotPassowrdState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class ResetPasswordSuccessState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class PhoneSignInState extends AuthenticationState {
  const PhoneSignInState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class PhoneSignInLoadingState extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialPhoneSignInState extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PhoneSignInLoadedState extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PhoneAuthCodeSentSuccessState extends AuthenticationState {
  final String verificationId;

  const PhoneAuthCodeSentSuccessState({required this.verificationId});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class PhoneSignInErrorState extends AuthenticationState {
  final String error;

  const PhoneSignInErrorState({required this.error});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SuccessPhoneSignInState extends AuthenticationState {
  final User user;

  const SuccessPhoneSignInState(this.user);

  @override
  List<Object?> get props => [];
}

class SignUpScreenOtpSuccessState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}
