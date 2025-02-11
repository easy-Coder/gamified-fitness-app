import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:gamified/src/features/hydration/model/water_intake.dart';
import 'package:gamified/src/features/hydration/presentation/add_hydration/controller/add_hydration_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class AddHydrationModal extends ConsumerStatefulWidget {
  const AddHydrationModal({super.key});

  @override
  ConsumerState<AddHydrationModal> createState() => _AddHydrationModalState();
}

class _AddHydrationModalState extends ConsumerState<AddHydrationModal> {
  final amount = ValueNotifier<int>(0);
  late final TextEditingController progressController;
  late final ShadSliderController sliderController;

  @override
  void initState() {
    super.initState();
    progressController = TextEditingController(text: amount.value.toString());
    amount.addListener(() {
      progressController.value =
          TextEditingValue(text: amount.value.toString());
    });
    progressController.addListener(() {
      amount.value = int.parse(progressController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final addHydrationState = ref.watch(addHydrationControllerProvider);
    ref.listen(addHydrationControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasValue) {
        context.pop();
      }
    });
    return DraggableSheet(
      child: SheetContentScaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              HydrationProgress(
                progress: amount.value.toDouble() * 0.1,
                size: Size.square(120),
                radius: 60,
              ),
              Text(
                'Water',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount.value.toString(),
                    style: ShadTheme.of(context).textTheme.h1Large,
                  ),
                  Text(
                    '/ml',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                ],
              ),
              ShadSlider(
                initialValue: amount.value.toDouble(),
                min: 0,
                max: 1000,
                divisions: 50,
                onChanged: (value) => setState(() {
                  amount.value = value.ceil();
                }),
              ),
              PrimaryButton(
                onTap: addHydrationState.isLoading
                    ? null
                    : () {
                        ref
                            .read(addHydrationControllerProvider.notifier)
                            .trackIntake(WaterIntakesCompanion.insert(
                              amount: amount.value,
                              drinkType: DrinkType.water,
                            ));
                      },
                isLoading: addHydrationState.isLoading,
                title: 'Add Water',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
