import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SignupRequest extends Equatable {
  final String username;
  final String email;
  final String state;
  final String avatarUrl;
  final String country;
  final String password;

  const SignupRequest(
      {required this.username,
      required this.email,
      required this.state,
      required this.avatarUrl,
      required this.country,
      required this.password});

  Map<String, dynamic> toMetaData() => {
    'username': username,
    'state': state,
    'country': country,
    'avatar_url': 'https://unsplash.com/photos/5bJBFSIB3ac/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8NHx8dXNlciUyMHByb2ZpbGV8ZW58MHx8fHwxNzI2NDI2NjIwfDA&force=true&w=640',
  };

  @override
  List<Object?> get props => [
        username,
        email,
        state,
        avatarUrl,
        country,
        password,
      ];
}
