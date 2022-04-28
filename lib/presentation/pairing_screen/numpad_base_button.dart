import 'package:flutter/material.dart';

class NumpadBaseButton extends StatelessWidget {
  const NumpadBaseButton({
    Key? key,
    this.callback,
    this.child,
  }) : super(key: key);

  final VoidCallback? callback;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          child: child
        )
      ),
    );
  }
}
