import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/application/exercise_log_service.dart';

class ExerciseLogPage extends ConsumerWidget {
  const ExerciseLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseLogs = ref.watch(exerciseLogsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Logs'),
      ),
      body: exerciseLogs.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Text('No exercise logs yet.'),
            );
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                title: Text(log.exerciseId),
                subtitle: Text(
                    'Sets: ${log.sets}, Reps: ${log.reps}, Weight: ${log.weight}'),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred.'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddExerciseLogDialog();
            },
          );
        },
        child: const Icon(Icons.add),
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
              decoration: const InputDecoration(
                labelText: 'Exercise ID',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an exercise ID.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _setsController,
              decoration: const InputDecoration(
                labelText: 'Sets',
              ),
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
              decoration: const InputDecoration(
                labelText: 'Reps',
              ),
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
              decoration: const InputDecoration(
                labelText: 'Weight',
              ),
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
