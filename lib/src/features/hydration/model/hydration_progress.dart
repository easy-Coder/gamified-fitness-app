import 'package:equatable/equatable.dart';

class HydrationProgress extends Equatable {
  final double todayHydrationTotal;
  final double hydrationGoal;

  const HydrationProgress({
    required this.todayHydrationTotal,
    required this.hydrationGoal,
  });

  @override
  List<Object?> get props => [];
}
