part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginSubmitEvent extends LoginEvent {
  final String phoneNumber;
  final String otp;
  final bool isforeign;
  final String email;
  final String deviceId;
  final String deviceType;
  final String token;
  const LoginSubmitEvent(
      {@required this.phoneNumber,
      @required this.otp,
      @required this.email,
      @required this.deviceId,
      @required this.deviceType,
      @required this.token,
      @required this.isforeign});

  @override
  List<Object> get props =>
      [phoneNumber, otp, isforeign, email, deviceType, deviceId];

  @override
  String toString() =>
      'LoginSubmitEvent { phoneNumber: $phoneNumber, otp: $otp ,isforeign:$isforeign,email:$email,deviceType:$deviceType,deviceId:$deviceId ,token:$token}';
}
