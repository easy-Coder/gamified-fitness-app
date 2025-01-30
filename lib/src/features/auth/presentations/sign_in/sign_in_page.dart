import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/password_input.dart';
import 'package:gamified/src/features/auth/data/request/signin_request.dart';
import 'package:gamified/src/features/auth/presentations/sign_in/controller/sign_in_controller.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:gamified/src/common/config/environment_config.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    ref.listenManual(signInControllerProvider, (state, _) {
      if (state?.isLoading == false && state?.hasError == true) {
        context.showErrorBar(
          content: Text((state?.error! as Failure).message),
          position: FlashPosition.top,
        );
      }
      if (state?.isLoading == false && state?.hasError == false) {
        context.showSuccessBar(
          content: const Text('Successfully Logged In'),
          position: FlashPosition.top,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(signInControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 16.h,
            left: 16.w,
            right: 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              48.verticalSpace,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadInput(
                  placeholder: Text('Email'),
                  onChanged: (value) => setState(() {
                    email = value;
                  }),
                ),
              ),
              8.verticalSpace,
              PasswordInput(
                onPasswordChange: (value) => password = value,
              ),
              48.verticalSpace,
              PrimaryButton(
                onTap: () {
                  ref.read(signInControllerProvider.notifier).login(
                        SignInRequest(
                          email: email,
                          password: password,
                        ),
                      );
                },
                isLoading: (signInState is AsyncLoading),
                title: 'Sign In',
              ),
              12.verticalSpace,
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Don't have account? "),
                    TextSpan(
                      text: "Register Here",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(AppRouter.register.name);
                        },
                      style: ShadTheme.of(context).textTheme.p.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                style: ShadTheme.of(context).textTheme.p,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
