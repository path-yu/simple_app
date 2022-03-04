import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';

Widget baseIcon(IconData icon) {
  return Icon(icon,
      color: navigatorKey.currentState!.context
          .watch<CurrentTheme>()
          .darkOrWhiteColor);
}
