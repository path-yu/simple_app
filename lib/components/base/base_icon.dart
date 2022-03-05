import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';

Widget baseIcon(IconData icon, {Color? color}) {
  return Icon(icon,
      color: color ??
          navigatorKey.currentState!.context
              .watch<CurrentTheme>()
              .darkOrWhiteColor);
}
