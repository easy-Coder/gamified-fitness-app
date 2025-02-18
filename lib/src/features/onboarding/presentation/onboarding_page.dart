import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/providers/db.dart';
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
  UserCompanion? user;
  GoalCompanion? goal;

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
      if (!state.isLoading && state.hasValue) {
        context.pushReplacementNamed(AppRouter.stats.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    return Scaffold(
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
                    icon: Icon(LucideIcons.arrowLeft),
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
                        height: 2,
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
                  UserProfileData(
                    onSave: (value) {
                      setState(() {
                        user = value;
                      });
                      _pageController.nextPage(
                        curve: Curves.easeInCubic,
                        duration: 250.milliseconds,
                      );
                    },
                  ),
                  GoalDataPage(
                    onSave: (value) {
                      setState(() {
                        goal = value;
                      });
                      _pageController.nextPage(
                        curve: Curves.easeInCubic,
                        duration: 250.milliseconds,
                      );
                    },
                  ),
                  CompleteOnboardingWidget(
                    isLoading: onboardingState.isLoading,
                    onTap: () {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding(user!, goal!);
                    },
                  ),
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
  const CompleteOnboardingWidget({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;

  final bool isLoading;

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
          Spacer(),
          PrimaryButton(title: 'Continue', onTap: onTap, isLoading: isLoading),
        ],
      ),
    );
  }
}
