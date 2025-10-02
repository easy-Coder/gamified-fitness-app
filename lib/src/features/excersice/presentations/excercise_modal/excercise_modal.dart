import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
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

  final _scrollController = ScrollController();
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    excercises = List.from(widget.excercises); // Create a mutable copy
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(exerciseControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final excerciseState = ref.watch(exerciseControllerProvider);
    return Sheet(
      child: SheetContentScaffold(
        topBar: SafeArea(
          bottom: false,
          right: false,
          left: false,
          child: Container(
            // height: 80.h,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.pop(
                    widget.excercises.isEmpty
                        ? <Exercise>[]
                        : widget.excercises,
                  ),
                  child: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: Icon(LucideIcons.x, size: 24),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (query) {
                      ref
                          .read(exerciseControllerProvider.notifier)
                          .search(query);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search (e.g Squat)...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: excerciseState.maybeWhen(
          data: (data) {
            final itemCount = data.haveMore
                ? data.exercises.length + 1
                : data.exercises.length;
            return SafeArea(
              child: data.exercises.isEmpty
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
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemBuilder: (context, index) {
                        // ✅ FIX: Check for the loading indicator FIRST
                        if (index == data.exercises.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Loading more exercise..."),
                            ),
                          );
                        }

                        // Now it's safe to access the exercise
                        final exercise = data.exercises[index];
                        final isSelected = excercises.contains(exercise);

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() {
                            if (isSelected) {
                              excercises.remove(exercise);
                              return;
                            }
                            excercises.add(exercise);
                          }),
                          child: Stack(
                            children: [
                              WorkoutExcerciseCard(exercise: exercise),
                              if (isSelected)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    padding: EdgeInsets.all(4.w),
                                    child: const Icon(
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
                      itemCount: itemCount,
                    ),
            );
          },
          error: (error, stackTrace) {
            debugPrintStack(stackTrace: stackTrace);
            return Center(
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
            );
          },
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
        bottomBar: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Container(
            height: 56.h,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
            child: PrimaryButton(
              onTap: () {
                context.pop(excercises);
              },
              title: excercises.length <= 1
                  ? 'Add (${excercises.length}) exercise'
                  : 'Add (${excercises.length}) exercises',
            ),
          ),
        ),
      ),
    );
  }
}
