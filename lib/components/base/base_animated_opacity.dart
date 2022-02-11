import 'package:flutter/material.dart';

baseAnimatedOpacity({required bool value, required Widget child}) {
  return AnimatedOpacity(
      opacity: value ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: child);
}
