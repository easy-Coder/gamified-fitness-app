import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/hydration/data/hydration_repo.dart';
import 'package:gamified/src/features/stats/application/service/stats_service.dart';
import 'package:gamified/src/features/stats/presentations/widgets/next_excercise_card.dart';
import 'package:gamified/src/features/stats/presentations/widgets/overview_section.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ShadAvatar(
                  'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                  placeholder: Text('CN'),
                  size: Size.square(48),
                ),
                8.horizontalSpace,
                Expanded(
                  child: userState.maybeWhen(
                    data: (user) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome,",
                          style: ShadTheme.of(
                            context,
                          ).textTheme.muted.copyWith(fontSize: 10),
                        ),
                        Text(
                          user!.name,
                          style: ShadTheme.of(context).textTheme.small,
                        ),
                      ],
                    ),
                    orElse: () => Column(
                      spacing: 2,
                      children: [
                        Container(
                          width: 20,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            NextExcerciseCard(),
            12.verticalSpace,
            OverviewSection(),
            // 8.verticalSpace,
            // HydrationCard(),
            60.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayStream = ref.watch(todayIntakeStreamProvider);
    return Container(
      height: 140.h,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
      child: todayStream.when(
        data: (data) {
          double progress = data / 3700;
          progress = progress > 1 ? 1 : progress;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HydrationProgressWidget(
                progress: progress * 100,
                size: Size.square(70),
                duration: Duration(milliseconds: 4000),
              ),
              20.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Daily Hydration Level',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                  Text(
                    '${data.ceil()} ml',
                    style: ShadTheme.of(context).textTheme.h3,
                  ),
                ],
              ),
              Spacer(),
              ShadButton.secondary(
                onPressed: () => context.pushNamed(AppRouter.addWater.name),
                decoration: ShadDecoration(shape: BoxShape.circle),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                leading: Icon(LucideIcons.plus),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
        error: (Object error, _) => Column(
          children: [
            Text(
              'Something went wrong',
              style: ShadTheme.of(context).textTheme.muted,
            ),
            PrimaryButton(
              title: 'Retry',
              onTap: () => ref.refresh(todayIntakeStreamProvider),
            ),
          ],
        ),
      ),
    );
  }
}
