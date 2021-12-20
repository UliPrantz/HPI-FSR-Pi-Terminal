import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ItemCount extends StatelessWidget {
  final int count;

  const ItemCount({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        color: AppColors.blue,
        child: Text(
          count.toString(),
          style: TextStyles.normalTextWhite
        ),
      ),
    );
  }
}