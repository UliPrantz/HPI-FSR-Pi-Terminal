import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class AppBarButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const AppBarButton({
    super.key,
    required this.text,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: callback,
      label: Text(text, style: TextStyles.appBarButton),
      icon: const Icon(Icons.logout),
    );
  }
}
