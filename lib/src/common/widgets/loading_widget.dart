import 'dart:math';

import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    super.key,
    this.color = Colors.white,
    this.size = 6,
    this.spacing = 3,
  });

  final Color color;
  final double size;
  final double spacing;

  @override
  State<LoadingWidget> createState() => _SequentialCircleLoaderState();
}

class _SequentialCircleLoaderState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create animation controller for continuous wave motion
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Start the animation and repeat infinitely
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          spacing: widget.spacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircle(0, widget.color),
            _buildCircle(1, widget.color),
            _buildCircle(2, widget.color),
          ],
        );
      },
    );
  }

  Widget _buildCircle(int index, Color color) {
    // Calculate wave motion with phase offset for each circle
    double waveValue = sin((_controller.value * 2 * pi) + (index * pi / 2));

    return Transform.translate(
      offset: Offset(0, -widget.size * waveValue),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
