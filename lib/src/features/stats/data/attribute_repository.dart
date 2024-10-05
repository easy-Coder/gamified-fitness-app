import 'package:dartz/dartz.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/stats/model/user_attributes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attribute_repository.g.dart';

class AttributeRepository {
  final SupabaseClient _client;

  const AttributeRepository(SupabaseClient client) : _client = client;

  Future<UserAttribute> getUserAttributes(
    String userId,
  ) async {
    try {
      print(userId);
      final response = await _client
          .from('user_attributes')
          .select()
          .eq('user_id', userId)
          .limit(1)
          .single();

      return UserAttributeMapper.fromMap(response);
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occure. Try again later');
    }
  }

  Future<void> updateUserAttributes(UserAttribute userAttribute) async {
    try {
      print(userAttribute.toMap());
      await _client
          .from('user_attributes')
          .update(userAttribute.toMap())
          .eq('user_id', userAttribute.userId);
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      throw Failure(message: 'Unexpected error occured');
    }
  }
}

@riverpod
AttributeRepository attributeRepo(AttributeRepoRef ref) {
  return AttributeRepository(ref.read(supabaseProvider));
}
