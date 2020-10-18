import 'dart:async';

import 'package:StackFinance/common/common.dart';
import 'package:StackFinance/login/login.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:StackFinance/login/repository/auth_repository.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repository = AuthRepository();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginInitiated) {
      yield LoggingIn();
      LogInOption logInOption = event.logInOption;
      switch (logInOption) {
        case LogInOption.Google:
          try {
            final _user = await _repository.signInWithGoogle();
            yield LoginSuccess(user: _user);
          } on PlatformException catch (e) {
            yield LoginFailure(errorMessage: e.message);
          } catch (e) {
            yield LoginFailure(errorMessage: 'Unexpected Error Occurred...');
          }
          break;
        case LogInOption.Facebook:
          break;
        case LogInOption.Github:
          break;
        default:
      }
    }
  }
}
