import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:gamified/src/features/hydration/application/hydration_service.dart';
import 'package:gamified/src/features/hydration/data/hydration_repo.dart';
import 'package:gamified/src/features/hydration/model/water_intake.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HydrationPage extends ConsumerWidget {
  const HydrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayStream = ref.watch(hydrationGoalProvider);
    final todayIntakeStream = ref.watch(todayIntakeListStreamProvider);
    final format = DateFormat('hh:mm a');
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                todayStream.maybeWhen(
                  data: (data) {
                    double progress =
                        data.todayHydrationTotal / data.hydrationGoal;
                    progress = progress > 1 ? 1 : progress;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HydrationProgressWidget(
                          progress: progress * 100,
                          size: Size.square(120),
                          radius: 60,
                          duration: Duration(milliseconds: 4000),
                        ),
                        20.verticalSpace,
                        Text.rich(
                          TextSpan(
                            text: data.todayHydrationTotal.toString(),
                            children: [
                              TextSpan(text: '/'),
                              TextSpan(text: data.hydrationGoal.toString()),
                              TextSpan(text: ' ml'),
                            ],
                            style: ShadTheme.of(context).textTheme.h2,
                          ),
                        ),
                      ],
                    );
                  },
                  orElse: () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HydrationProgressWidget(
                        progress: 0 * 100,
                        size: Size.square(70),
                        duration: Duration(milliseconds: 800),
                        radius: 20,
                      ),

                      20.verticalSpace,
                      Text.rich(
                        TextSpan(
                          text: '1665',
                          children: [
                            TextSpan(text: '/'),
                            TextSpan(text: '3700'),
                            TextSpan(text: 'ml'),
                          ],
                          style: ShadTheme.of(context).textTheme.h2,
                        ),
                      ),
                    ],
                  ),
                ),

                20.verticalSpace,
                Text(
                  "Today's Recap",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                8.verticalSpace,
                Flexible(
                  child: todayIntakeStream.when(
                    data: (data) => data.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You haven't logs any drink you have yet.",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) => index != 12
                                ? Container(
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: Colors.grey.shade100,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 64.w,
                                          height: 64.w,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                          ),
                                        ),
                                        8.horizontalSpace,
                                        Flexible(
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    data[index].drinkType.name
                                                        .toTitleCase(),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  4.horizontalSpace,
                                                  Text(
                                                    "${data[index].drinkType.hydrationFactor} %",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          data[index]
                                                              .drinkType
                                                              .hydrationFactor
                                                              .isNegative
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${data[index].amount} ml",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            format.format(data[index].time),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : 60.verticalSpace,
                            separatorBuilder: (context, index) =>
                                8.verticalSpace,
                            itemCount: data.length,
                          ),

                    error: (error, st) => Container(),
                    loading: () =>
                        Center(child: CircularProgressIndicator.adaptive()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
