import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:gamified/src/features/onboarding/presentation/widget/goal_data.dart';
import 'package:gamified/src/features/onboarding/presentation/widget/user_profile_data.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex, keepPage: true);

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page!.ceil();
      });
    });

    ref.listenManual(onboardingControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        return;
      }
      if (!state.isLoading && state.hasValue) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final user = ref.watch(userModelStateProvider);
    final goal = ref.watch(goalModelStateProvider);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: PrimaryButton(
            title: currentIndex < 2 ? 'Save' : 'Continue',
            isLoading: onboardingState.isLoading,
            onTap:
                currentIndex < 2
                    ? () {
                      if (currentIndex == 0 && user.isEmpty) return;
                      if (currentIndex == 1 && goal.isEmpty) return;
                      _pageController.nextPage(
                        curve: Curves.easeInCubic,
                        duration: 250.milliseconds,
                      );
                    }
                    : () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding(user!, goal!);
                      if (context.mounted) {
                        context.goNamed(AppRouter.stats.name);
                      }
                    },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 4,
                children: [
                  ShadButton.secondary(
                    child: Icon(LucideIcons.arrowLeft),
                    onPressed:
                        () => _pageController.previousPage(
                          curve: Curves.easeInCubic,
                          duration: 250.milliseconds,
                        ),
                  ),
                  ...List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        width: 48.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color:
                              index <= currentIndex
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UserProfileData(),
                  GoalDataPage(),
                  CompleteOnboardingWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompleteOnboardingWidget extends StatelessWidget {
  const CompleteOnboardingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Assets.svg.done.svg(width: 320.w, height: 240.w),
          Text(
            'That\'s All For Now.',
            style: ShadTheme.of(context).textTheme.h4,
            textAlign: TextAlign.center,
          ),
          Text(
            'Click on the \'continue\' to start your healthy journey.',
            style: ShadTheme.of(context).textTheme.p,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
