import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/excersice/presentations/excercise_modal/controller/excercise_controller.dart';
import 'package:gamified/src/features/excersice/presentations/excercise_modal/widgets/excercise_card.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ExcerciseModal extends ConsumerStatefulWidget {
  const ExcerciseModal({
    super.key,
    required this.excercises,
  });

  final List<Excercise> excercises;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExcerciseModalState();
}

class _ExcerciseModalState extends ConsumerState<ExcerciseModal> {
  List<Excercise> excercises = [];

  @override
  void initState() {
    super.initState();
    excercises = widget.excercises;
  }

  @override
  Widget build(BuildContext context) {
    final excerciseState = ref.watch(excerciseControllerProvider);
    return ScrollableSheet(
      child: SheetContentScaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            child: Container(
              // height: 56.h,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    // onChanged: (value) => setState(() {
                    //   email = value;
                    // }),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade900,
                        ),
                      ),
                      hintText: 'Search Excersice',
                      hintStyle: GoogleFonts.rubikMonoOne(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                      suffixIcon: IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          color: Colors.grey.shade900,
                        ),
                        onPressed: () {},
                      ),
                      constraints: BoxConstraints.tight(Size.fromHeight(45.h)),
                    ),
                    onSubmitted: (value) {},
                    style: GoogleFonts.rubik(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ), 8.verticalSpace,
                  Row(
                    children: [
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: excerciseState.maybeWhen(
          data: (data) => NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // debugPrint(scrollInfo.metrics.extentAfter.toString());
              if (scrollInfo is ScrollEndNotification &&
                  scrollInfo.metrics.extentAfter == 0) {
                ref.read(excerciseControllerProvider.notifier).loadNextPage();
              }
              return true;
            },
            child: SafeArea(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return ref
                            .read(excerciseControllerProvider.notifier)
                            .hasMoreItems
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(child: Text('No more items'));
                  }
                  final isSelected = excercises.contains(data[index]);
                  return ExcerciseCard(
                    value: isSelected,
                    onSelected: (value) => setState(() {
                      if (isSelected) {
                        excercises.removeWhere((item) => item == data[index]);
                        return;
                      }
                      excercises.add(value);
                    }),
                    excercise: data[index],
                  );
                },
                separatorBuilder: (context, _) => 4.verticalSpace,
                itemCount: data.length,
              ),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (error as Failure).message,
                ),
                8.verticalSpace,
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(excerciseControllerProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                    textStyle: GoogleFonts.rubik(
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: Size(120.w, 45.h),
                  ),
                  child: const Text('Retry'),
                )
              ],
            ),
          ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomBar: BottomAppBar(
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                    foregroundColor: Colors.black,
                    textStyle: GoogleFonts.rubik(
                      fontSize: 16.sp,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              16.horizontalSpace,
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(excercises);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                    textStyle: GoogleFonts.rubik(
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
