import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    player.open(
      Media('asset:///assets/welcome/welcome.mp4'),
    );
    player.setPlaylistMode(PlaylistMode.single);
    controller = VideoController(player);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Video(
            // height: MediaQuery.sizeOf(context).height,
            // width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
            controller: controller,
            controls: NoVideoControls,
            wakelock: false,
            resumeUponEnteringForegroundMode: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  30.verticalSpace,
                  Text(
                    'Fitness App',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubikMonoOne(
                      color: Colors.white,
                      fontSize: 28.sp,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppRouter.register.name);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[900],
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 15.h),
                      textStyle: GoogleFonts.pressStart2p(
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                  24.verticalSpace,
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRouter.signin.name);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.rubikMonoOne(
                        fontSize: 14,
                      ),
                    ),
                    child: const Text('Sign In'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
