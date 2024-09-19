import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SignInRequest extends Equatable {
  final String email;
  final String password;

  const SignInRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
