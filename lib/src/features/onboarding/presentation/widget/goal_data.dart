import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/schema/goal.dart'
    show FitnessGoal;
import 'package:shadcn_ui/shadcn_ui.dart';

class GoalDataPage extends StatefulWidget {
  const GoalDataPage({super.key, required this.onSave});

  final void Function(GoalModel goal) onSave;

  @override
  State<GoalDataPage> createState() => _GoalDataPageState();
}

class _GoalDataPageState extends State<GoalDataPage> {
  FitnessGoal? selectedFitnessGoal;
  double? selectedWeight;
  double? selectedFluid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShadForm(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tell us your goal',
              style: ShadTheme.of(context).textTheme.h1,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            SettingsListItem(
              title: 'Fitness Goal',
              value: selectedFitnessGoal?.name.toSpaceSeperated().toTitleCase(),
              onTap: () async {
                final fitnessGoal = await MeasureModalSheet.showModalSheet(
                  context,
                  MeasureModalSheet(
                    title: 'Select You Fitness Goal',
                    itemCount: FitnessGoal.values.length,
                    builder:
                        (context, index, currentIndex) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            FitnessGoal.values[index].name
                                .toSpaceSeperated()
                                .toTitleCase(),
                            style: ShadTheme.of(
                              context,
                            ).textTheme.small.copyWith(
                              color:
                                  index == currentIndex ? Colors.white : null,
                            ),
                          ),
                        ),
                  ),
                );
                setState(() {
                  selectedFitnessGoal = FitnessGoal.values[fitnessGoal];
                });
              },
            ),
            8.horizontalSpace,
            SettingsListItem(
              title: 'Target Weight',
              value: selectedWeight?.toString(),
              onTap: () async {
                double printWeight(index) => (20.0 + (index / 10));
                final weight = await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Your Target Weight',
                    itemCount: 9800,
                    builder:
                        (BuildContext context, int index, int currentIndex) =>
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${printWeight(index)} kg',
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.small.copyWith(
                                  color:
                                      index == currentIndex
                                          ? Colors.white
                                          : null,
                                ),
                              ),
                            ),
                  ),
                );
                setState(() {
                  selectedWeight = printWeight(weight!);
                });
              },
            ),
            8.horizontalSpace,
            SettingsListItem(
              title: 'Target Fluid',
              value: selectedFluid?.toString(),
              onTap: () async {
                final index = await MeasureModalSheet.showModalSheet(
                  context,
                  MeasureModalSheet(
                    title: 'Select You Target Fluid',
                    itemCount: 12,
                    builder:
                        (context, index, currentIndex) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${1000 + (250 * index)} ml',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.small.copyWith(
                              color:
                                  index == currentIndex ? Colors.white : null,
                            ),
                          ),
                        ),
                  ),
                );
                setState(() {
                  selectedFluid = (1000 + (250 * index!)).toDouble();
                });
              },
            ),
            Spacer(),
            PrimaryButton(
              title: 'Save',
              onTap: () {
                if (selectedFitnessGoal == null &&
                    selectedFluid == null &&
                    selectedWeight == null) {
                  return;
                }
                widget.onSave(
                  GoalModel(
                    fitnessGoal: selectedFitnessGoal!,
                    targetWeight: selectedWeight!,
                    hydrationGoal: selectedFluid!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
