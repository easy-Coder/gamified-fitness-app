import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/schema/goal.dart'
    show FitnessGoal;
import 'package:shadcn_ui/shadcn_ui.dart';

final goalModelStateProvider = StateProvider<GoalModel>(
  (_) => GoalModel.empty(),
);

class GoalDataPage extends ConsumerStatefulWidget {
  const GoalDataPage({super.key});

  @override
  ConsumerState<GoalDataPage> createState() => _GoalDataPageState();
}

class _GoalDataPageState extends ConsumerState<GoalDataPage> {
  @override
  Widget build(BuildContext context) {
    final goalModel = ref.watch(goalModelStateProvider);
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
              value:
                  goalModel.fitnessGoal.name.toSpaceSeperated().toTitleCase(),
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

                ref.read(goalModelStateProvider.notifier).state = goalModel
                    .copyWith(fitnessGoal: FitnessGoal.values[fitnessGoal]);
              },
            ),
            8.horizontalSpace,
            SettingsListItem(
              title: 'Target Weight',
              value:
                  goalModel.targetWeight != 0
                      ? goalModel.targetWeight.toString()
                      : null,
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
                ref.read(goalModelStateProvider.notifier).state = goalModel
                    .copyWith(targetWeight: printWeight(weight!));
              },
            ),
            8.horizontalSpace,
            SettingsListItem(
              title: 'Target Fluid',
              value:
                  goalModel.hydrationGoal != 0
                      ? goalModel.hydrationGoal.toString()
                      : null,
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
                  ref.read(goalModelStateProvider.notifier).state = goalModel
                      .copyWith(
                        hydrationGoal: (1000 + (250 * index!)).toDouble(),
                      );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
