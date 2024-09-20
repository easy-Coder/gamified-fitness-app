import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/auth/data/request/signup_request.dart';
import 'package:gamified/src/features/auth/presentations/sign_up/controller/sign_up_controller.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  String username = '';
  String email = '';
  String password = '';
  String state = '';
  String country = '';

  @override
  void initState() {
    super.initState();
    ref.listenManual(signUpControllerProvider, (state, _) {
      if (state is AsyncError) {
        context.showErrorBar(
          content: Text((state?.error! as Failure).message),
          position: FlashPosition.top,
        );
      }
      if (state is AsyncData) {
        context.showSuccessBar(
          content: const Text('Successfully Logged In'),
          position: FlashPosition.top,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpControllerProvider);
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
                'Signup',
                style: GoogleFonts.rubikMonoOne(
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
              48.verticalSpace,
              TextField(
                onChanged: (value) => setState(() {
                  username = value;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  hintText: 'Username',
                  hintStyle: GoogleFonts.rubikMonoOne(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: GoogleFonts.rubik(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              8.verticalSpace,
              TextField(
                onChanged: (value) => setState(() {
                  email = value;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  hintText: 'Email',
                  hintStyle: GoogleFonts.rubikMonoOne(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: GoogleFonts.rubik(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              8.verticalSpace,
              TextField(
                onChanged: (value) => setState(() {
                  state = value;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  hintText: 'State',
                  hintStyle: GoogleFonts.rubikMonoOne(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: GoogleFonts.rubik(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              8.verticalSpace,
              TextField(
                onChanged: (value) => setState(() {
                  country = value;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  hintText: 'Country',
                  hintStyle: GoogleFonts.rubikMonoOne(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: GoogleFonts.rubik(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              8.verticalSpace,
              TextField(
                onChanged: (value) => setState(() {
                  password = value;
                }),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  hintText: 'Password',
                  hintStyle: GoogleFonts.rubikMonoOne(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: GoogleFonts.rubik(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              48.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  ref.read(signUpControllerProvider.notifier).signUp(
                        SignupRequest(
                          username: username,
                          email: email,
                          state: state,
                          avatarUrl: '',
                          country: country,
                          password: password,
                        ),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                  textStyle: GoogleFonts.pressStart2p(
                    fontSize: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: (signUpState is AsyncLoading)
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : const Text('Register'),
              ),
              12.verticalSpace,
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Already have account? "),
                    TextSpan(
                      text: "Login Here",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(AppRouter.signin.name);
                        },
                      style: GoogleFonts.rubik(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                style: GoogleFonts.rubik(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
