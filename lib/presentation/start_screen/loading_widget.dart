import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({ super.key });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1300), vsync: this);
    _animation = Tween<double>(begin: 10.0, end: 23.0).animate(_controller);
    _animation.addListener(() => setState(() {}));
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "FSR-Terminal",
            style: TextStyles.loadingTextStyle.copyWith(
              shadows: <Shadow>[
                Shadow(
                  color: Colors.white70,
                  blurRadius: _animation.value,
                )
              ]
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
