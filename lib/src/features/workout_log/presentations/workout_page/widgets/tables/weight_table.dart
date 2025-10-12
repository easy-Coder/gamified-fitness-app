import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WeightWorkoutTable extends StatelessWidget {
  final ExerciseDTO exercise;
  final List<ExerciseLogsDTO> exerciseLogs;
  final void Function(int index) onSave;
  final void Function(int index) onRemove;
  final void Function(int index, ExerciseLogsDTO log) onUpdate;
  final List<ExerciseLogsDTO> savedLogs;

  const WeightWorkoutTable({
    super.key,
    required this.exercise,
    required this.exerciseLogs,
    required this.onSave,
    required this.onRemove,
    required this.onUpdate,
    required this.savedLogs,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER ROW
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _headerCell("Set"),
                _headerCell("Reps"),
                _headerCell("Weight"),
                Spacer(),
                _headerCell(null, Icon(LucideIcons.check, color: Colors.green)),
              ],
            ),
          ),

          /// DATA ROWS
          ...List.generate(exerciseLogs.length, (index) {
            final row = exerciseLogs[index];
            return _buildRow(
              ValueKey(row.sets),
              onRemove: () => onRemove(index),
              children: [
                _dataCell(Text("${row.sets}")),
                _dataCell(
                  _dataInputField(
                    placeholder: "reps",
                    onChanged: (value) {
                      final newLog = row.copyWith(reps: int.tryParse(value));
                      onUpdate(index, newLog);
                    },
                  ),
                ),
                _dataCell(
                  _dataInputField(
                    placeholder: "kg",
                    onChanged: (value) {
                      final newLog = row.copyWith(
                        weight: double.tryParse(value),
                      );
                      onUpdate(index, newLog);
                    },
                  ),
                ),
                Spacer(),
                _dataCell(
                  GestureDetector(
                    onTap: () => onSave(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: savedLogs.contains(row)
                            ? Colors.green
                            : Colors.grey.shade100,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.check,
                        color: savedLogs.contains(row)
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(
    Key key, {
    required List<Widget> children,
    required VoidCallback onRemove,
  }) => Slidable(
    key: key,
    endActionPane: ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.3,
      children: [
        SlidableAction(
          onPressed: (context) => onRemove(),
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          label: 'Delete',
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(children: children),
    ),
  );

  Widget _dataInputField({
    required String placeholder,
    required void Function(String value) onChanged,
    TextInputType keyboardType = TextInputType.number,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return TextField(
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey.withAlpha(250)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
      ),
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
    );
  }

  Widget _headerCell([String? text, Widget? lead]) {
    assert(text != null || lead != null);
    return lead != null
        ? Flexible(child: Center(child: lead))
        : Expanded(
            child: Text(
              text!,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _dataCell(Widget child) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(child: child),
      ),
    );
  }
}
