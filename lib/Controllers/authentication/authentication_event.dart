part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignUpEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const SignUpEvent({required this.email, required this.password});
  @override
  List<Object?> get props => throw UnimplementedError();
}

//after verified trigger this event
class VerifiedUserEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [];
}

class LoadLoginScreenEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadSignUpScreenEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GoogleSignInEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

/// forgot password event
class ForgotPasswordEvent extends AuthenticationEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});
  @override
  List<Object?> get props => [];
}

/// forgot password screen loading event
class LoadingForgotPasswordScreen extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

//class initial event
class AuthenticationInitialEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class PhoneSignInEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class SendOtpToPhoneEvent extends AuthenticationEvent {
  final String phoneNumber;

  const SendOtpToPhoneEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [];
}

class OnPhoneOtpSentEvent extends AuthenticationEvent {
  final String verificationId;
  final int? token;

  const OnPhoneOtpSentEvent({
    required this.verificationId,
    required this.token,
  });

  @override
  List<Object?> get props => [];
}

class VerifySentOtpEvent extends AuthenticationEvent {
  final String otpCode;
  final String verificationId;

  const VerifySentOtpEvent(
      {required this.otpCode, required this.verificationId});

  @override
  List<Object?> get props => [];
}

class OnPhoneAuthErrorEvent extends AuthenticationEvent {
  final String error;
  const OnPhoneAuthErrorEvent({required this.error});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnPhoneAuthVerificationCompletedEvent extends AuthenticationEvent {
  final AuthCredential credential;

  const OnPhoneAuthVerificationCompletedEvent({required this.credential});

  @override
  List<Object?> get props => [];
}
