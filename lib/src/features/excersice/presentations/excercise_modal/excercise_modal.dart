import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/excersice/presentations/excercise_modal/controller/excercise_controller.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ExcerciseModal extends ConsumerStatefulWidget {
  const ExcerciseModal({super.key, required this.excercises});

  final List<Exercise> excercises;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExcerciseModalState();
}

class _ExcerciseModalState extends ConsumerState<ExcerciseModal> {
  List<Exercise> excercises = [];

  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    excercises = widget.excercises;
    searchController = TextEditingController();

    searchController.addListener(() {
      if (searchController.text.isEmpty) return;

      ref
          .read(exerciseControllerProvider.notifier)
          .searchExcercise(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final excerciseState = ref.watch(exerciseControllerProvider);
    return ScrollableSheet(
      child: SheetContentScaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            child: Container(
              // height: 56.h,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(LucideIcons.x),
                  ),
                  Expanded(
                    child: ShadInput(
                      controller: searchController,
                      placeholder: Text('Search for Workout (e.g Squat)...'),
                      decoration: ShadDecoration(
                        border: ShadBorder.all(width: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: excerciseState.maybeWhen(
          data:
              (data) => SafeArea(
                child:
                    data.isEmpty
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.svg.search.svg(width: 120.w, height: 180.w),
                            Text(
                              'No search result yet',
                              style: ShadTheme.of(context).textTheme.h4,
                            ),
                            Text(
                              searchController.text.isEmpty
                                  ? 'Start typing to see the workouts you want.'
                                  : 'Query "${searchController.text}" doesn\'t return any result',
                              style: ShadTheme.of(context).textTheme.muted,
                            ),
                          ],
                        )
                        : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          itemBuilder: (context, index) {
                            final isSelected = excercises.contains(data[index]);
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  () => setState(() {
                                    if (isSelected) {
                                      excercises.removeWhere(
                                        (item) => item == data[index],
                                      );
                                      return;
                                    }
                                    excercises.add(data[index]);
                                  }),
                              child: Stack(
                                children: [
                                  WorkoutExcerciseCard(exercise: data[index]),
                                  if (isSelected)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        padding: EdgeInsets.all(4.w),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, _) => 4.verticalSpace,
                          itemCount: data.length,
                        ),
              ),
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text((error as Failure).message),
                    8.verticalSpace,
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(exerciseControllerProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 35.w,
                          vertical: 15.h,
                        ),
                        textStyle: GoogleFonts.rubik(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(120.w, 45.h),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
        bottomBar: BottomAppBar(
          child: ShadButton(
            onPressed: () {
              context.pop(excercises);
            },
            decoration: ShadDecoration(
              border: ShadBorder.all(radius: BorderRadius.circular(24.r)),
            ),
            child: Text(
              excercises.length <= 1
                  ? 'Add (${excercises.length}) exercise'
                  : 'Add (${excercises.length}) excercises',
            ),
          ),
        ),
      ),
    );
  }
}
