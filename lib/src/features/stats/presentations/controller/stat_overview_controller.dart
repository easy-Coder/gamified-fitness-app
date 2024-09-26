import 'package:gamified/src/features/stats/application/service/stats_service.dart';
import 'package:gamified/src/features/stats/application/stat_overview_model/overview_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stat_overview_controller.g.dart';

@riverpod
class StatOverviewController extends _$StatOverviewController {
  @override
  Future<OverviewModel> build() async {
    final resp = await ref.read(statServiceProvider).getStatOverview();
    state =  resp.fold(
        (failure) => AsyncError(failure, StackTrace.current),
        (value) => AsyncData(value),
      );
    return state.value!;
  }
}
