import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GifEmulator extends StatefulWidget {
  final List<String> imagePaths;

  const GifEmulator({
    super.key,
    required this.imagePaths,
  });

  @override
  _GifEmulatorState createState() => _GifEmulatorState();
}

class _GifEmulatorState extends State<GifEmulator> {
  // late Timer _timer;
  int _currentIndex = 0;

  void _changeImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeImage,
      child: CachedNetworkImage(
        width: 240.w,
        height: 240.w,
        imageUrl:
            'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/${widget.imagePaths[_currentIndex]}',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Image.asset(
          'assets/logo/logo.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
