import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/application/exercise_log_service.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/workout_log_duration.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key, required this.workoutPlanId});

  final int workoutPlanId;

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  Duration _duration = Duration.zero;
  bool isTimerActive = true;
  @override
  Widget build(BuildContext context) {
    final workoutPlan = ref.watch(workoutPlanProvider(widget.workoutPlanId));
    return workoutPlan.when(
      data: (data) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              WorkoutLogDuration(
                onDurationChanged: (duration) {
                  setState(() {
                    _duration = duration;
                  });
                },
                isActive: isTimerActive,
              ),
              Text(data.name, style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: [ShadButton.link(child: Text("Done"))],
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemBuilder: (context, index) =>
              ExerciseCard(workoutExcercise: data.workoutExercise[index]),
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemCount: data.workoutExercise.length,
        ),
      ),
      error: (error, _) {
        return Scaffold(body: Text(error.toString()));
      },
      loading: () => CircularProgressIndicator.adaptive(),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.workoutExcercise});

  final WorkoutExercise workoutExcercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 2.9,
            spreadRadius: .9,
            offset: Offset(1, 2),
          ),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    workoutExcercise.exercise.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              ShadButton.link(
                size: ShadButtonSize.sm,
                padding: EdgeInsets.zero,
                foregroundColor: Colors.blue,
                child: Text("Show Instruction"),
              ),
            ],
          ),
          12.verticalSpace,

          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Set')),
              DataColumn(label: Text('Reps')),
              DataColumn(label: Text('Weight')),
              DataColumn(label: Text('')),
            ],
            rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('1')),
                  DataCell(Text('25')),
                  DataCell(Text('10')),
                  DataCell(Icon(LucideIcons.x600, color: Colors.red)),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('2')),
                  DataCell(Text('25')),
                  DataCell(Text('10')),
                  DataCell(
                    Icon(LucideIcons.x600, color: Colors.red),
                    onTap: () => print("Deleting sets 2"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddExerciseLogDialog extends ConsumerStatefulWidget {
  const AddExerciseLogDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddExerciseLogDialogState();
}

class _AddExerciseLogDialogState extends ConsumerState<AddExerciseLogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseIdController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Exercise Log'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _exerciseIdController,
              decoration: const InputDecoration(labelText: 'Exercise ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an exercise ID.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _setsController,
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of sets.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of reps.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the weight.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the duration.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final navigator = Navigator.of(context);
              final entry = ExerciseLogsCompanion(
                exerciseId: drift.Value(_exerciseIdController.text),
                sets: drift.Value(int.parse(_setsController.text)),
                reps: drift.Value(int.parse(_repsController.text)),
                weight: drift.Value(double.parse(_weightController.text)),
                duration: drift.Value(int.parse(_durationController.text)),
              );
              await ref.read(exerciseLogServiceProvider).addExerciseLog(entry);
              ref.invalidate(exerciseLogsProvider);
              navigator.pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
