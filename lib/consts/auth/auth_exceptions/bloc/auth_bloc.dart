import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_provider.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //sendEmailVErification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerificaton();
        emit(state);
      },
    );
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });
    //login
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: "Please Wait while we log you in.",
        ));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logInUser(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    //logout
    #TODO;
    on<AuthEventLogout>(
      (event, emit) async {
        emit(const AuthStateLoading(isLoading: true));
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(isLoading: false, exception: null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    //Register
    on<AuthEventRegister>(
      (event, emit) async {
        emit(const AuthStateLoading(isLoading: true));
        try {
          final email = event.email;
          final password = event.password;
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerificaton();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) async {
        ///emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        try {
          emit(const AuthStateRegister(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }

        //emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      },
    );
    on<AuthEventResetPassword>(
      (event, emit) async {
        emit(const AuthStateResetPassword(
          emailSent: false,
          isLoading: false,
          exception: null,
        ));
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(email: event.email.toString());
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(AuthStateResetPassword(
          exception: exception,
          emailSent: didSendEmail,
          isLoading: false,
        ));
      },
    );
    // on<AuthEventEmailVerification>(
    //   (event, emit) async{
    //     emit(const AuthStateLoading());
    //     try{
    //       await provider.sendEmailVerificaton();
    //     }on Exception catch(e){
    //       emit
    //     }

    //   },
    // );
  }
}
