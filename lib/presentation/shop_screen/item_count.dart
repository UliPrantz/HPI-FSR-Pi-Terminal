import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ItemCount extends StatelessWidget {
  final int count;

  const ItemCount({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(count.toString(), style: TextStyles.normalTextBlackBold),
    );
  }
}
