import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
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

  DrinkType selectedType = DrinkType.water;

  @override
  void initState() {
    super.initState();
    progressController = TextEditingController(text: amount.value.toString());
    amount.addListener(() {
      progressController.value = TextEditingValue(
        text: amount.value.toString(),
      );
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
    return Sheet(
      child: SheetContentScaffold(
        topBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              HydrationProgressWidget(
                progress: amount.value.toDouble() * 0.1,
                size: Size.square(120),
                radius: 60,
                duration: Duration(milliseconds: 3000),
              ),
              20.verticalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 56.h),
                child: FluidTypeSelectionList(
                  selectedType: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
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
                  Text('/ml', style: ShadTheme.of(context).textTheme.muted),
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
                onTap: () {
                  ref
                      .read(addHydrationControllerProvider.notifier)
                      .trackIntake(
                        WaterIntakesCompanion.insert(
                          amount: amount.value,
                          drinkType: selectedType,
                        ),
                      );
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

class FluidTypeSelectionList extends StatefulWidget {
  const FluidTypeSelectionList({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final DrinkType selectedType;
  final Function(DrinkType value) onChanged;

  @override
  State<FluidTypeSelectionList> createState() => _FluidTypeSelectionListState();
}

class _FluidTypeSelectionListState extends State<FluidTypeSelectionList> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        SizedBox.expand(),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 160.w,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
        ),
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) => widget.onChanged(DrinkType.values[index]),
          itemCount: DrinkType.values.length,
          itemBuilder: (context, index) => Container(
            // decoration: BoxDecoration(
            //   color: isSelected(widget.selectedType, index)
            //       ? Colors.black87
            //       : null,
            //   borderRadius: BorderRadius.circular(100.r),
            // ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            alignment: Alignment.center,
            child: isSelected(widget.selectedType, index)
                ? Text(
                    DrinkType.values[index].name
                        .toSpaceSeperated()
                        .toTitleCase(),
                    style: ShadTheme.of(
                      context,
                    ).textTheme.h4.copyWith(color: Colors.white, fontSize: 18),
                  )
                : Text(
                    DrinkType.values[index].name
                        .toSpaceSeperated()
                        .toTitleCase(),
                    style: ShadTheme.of(
                      context,
                    ).textTheme.small.copyWith(color: Colors.grey.shade600),
                  ),
          ),
        ),
      ],
    );
  }

  isSelected(DrinkType type, int index) => type == DrinkType.values[index];
}
