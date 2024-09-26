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

  Future< UserAttribute> getUserAttributes(
    String user_id,
  ) async {
    try {
      final response = await _client
          .from('user_attributes')
          .select()
          .eq('user_id', user_id)
          .single();
      return UserAttributeMapper.fromMap(response);
    } on PostgrestException catch (error) {
      throw Failure(message: error.message);
    } catch (error) {
      throw Failure(message: 'Unexpected error occure. Try again later');
    }
  }

  Future<void> updateUserAttributes(
      UserAttribute userAttribute) async {
    try {
      await _client.from('user_attributes').upsert(userAttribute.toMap());
      
    } on PostgrestException catch (error) {
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