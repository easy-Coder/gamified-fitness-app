import 'package:dartz/dartz.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/auth/data/request/signin_request.dart';
import 'package:gamified/src/features/auth/data/request/signup_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  const AuthRepository(SupabaseClient client) : _client = client;

  Stream<AuthState> authStateChange() => _client.auth.onAuthStateChange;

  User? currentUser() => _client.auth.currentUser;

  Future<Either<Failure, User>> signIn(SignInRequest req) async {
    try {
      final response = await _client.auth
          .signInWithPassword(password: req.password, email: req.email);
      return Right(response.user!);
    } on AuthException catch (error) {
      return Left(Failure(message: error.message));
    } catch (error) {
      return Left(Failure(message: "Something went wrong. Try Again"));
    }
  }

  Future<Either<Failure, User>> signUp(SignupRequest signUpRequest) async {
    try {
      final response = await _client.auth.signUp(
        password: signUpRequest.password,
        email: signUpRequest.email,
        data: signUpRequest.toMetaData(),
      );
      return Right(response.user!);
    } on AuthException catch (error) {
      return Left(Failure(message: error.message));
    } catch (error) {
      return Left(Failure(message: "Something went wrong. Try Again"));
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository(
      ref.read(supabaseProvider),
    ));

final authChangeProvider = StreamProvider.autoDispose<AuthState>(
    (ref) => ref.read(authRepositoryProvider).authStateChange());

final currentUserProvider =
    Provider((ref) => ref.read(authRepositoryProvider).currentUser());
