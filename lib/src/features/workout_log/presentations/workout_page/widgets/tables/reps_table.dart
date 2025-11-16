import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/app_text_theme.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RepsWorkoutTable extends StatelessWidget {
  final ExerciseDTO exercise;
  final List<ExerciseLogsDTO> exerciseLogs;
  final void Function(int index) onSave;
  final void Function(int index) onRemove;
  final void Function(int index, ExerciseLogsDTO log) onUpdate;
  final List<ExerciseLogsDTO> savedLogs;

  const RepsWorkoutTable({
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
    final appColors = context.appColors;
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER ROW
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: appColors.grey300),
              ),
            ),
            child: Row(
              children: [
                _headerCell(context, "Set"),
                _headerCell(context, "Reps"),
                Spacer(),
                _headerCell(
                  context,
                  null,
                  Icon(LucideIcons.check, color: appColors.success),
                ),
              ],
            ),
          ),

          /// DATA ROWS
          ...List.generate(exerciseLogs.length, (index) {
            final row = exerciseLogs[index];
            return _buildRow(
              context,
              ValueKey(row.sets),
              onRemove: () => onRemove(index),
              children: [
                _dataCell(context, Text("${row.sets}")),
                _dataCell(
                  context,
                  _dataInputField(
                    context,
                    placeholder: "reps",
                    onChanged: (value) {
                      final newLog = row.copyWith(reps: int.tryParse(value));
                      onUpdate(index, newLog);
                    },
                  ),
                ),
                Spacer(),
                _dataCell(
                  context,
                  GestureDetector(
                    onTap: () => onSave(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        color: savedLogs.contains(row)
                            ? appColors.success
                            : appColors.grey100,
                      ),
                      padding: EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        LucideIcons.check,
                        color: savedLogs.contains(row)
                            ? appColors.onSuccess
                            : appColors.grey600,
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
    BuildContext context,
    Key key, {
    required List<Widget> children,
    required VoidCallback onRemove,
  }) {
    final appColors = context.appColors;
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => onRemove(),
            backgroundColor: appColors.error,
            foregroundColor: appColors.onError,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: appColors.grey300),
          ),
        ),
        child: Row(children: children),
      ),
    );
  }

  Widget _dataInputField(
    BuildContext context, {
    required String placeholder,
    required void Function(String value) onChanged,
    TextInputType keyboardType = TextInputType.number,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    final appColors = context.appColors;
    return TextField(
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholder,
        hintStyle: TextStyle(color: appColors.grey600.withAlpha(250)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
      ),
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
    );
  }

  Widget _headerCell(BuildContext context, [String? text, Widget? lead]) {
    assert(text != null || lead != null);
    return lead != null
        ? Flexible(child: Center(child: lead))
        : Expanded(
            child: Text(
              text!,
              style: AppTextTheme.labelLarge(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _dataCell(BuildContext context, Widget child) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Center(child: child),
      ),
    );
  }
}
