import 'package:flutter/material.dart';
import 'package:simple_app/components/base/tabs.dart';
import 'package:simple_app/page/calculator.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';

final routes = {
  '/': (BuildContext context) => const Tabs(),
  '/todo_list_page': (BuildContext context) => const TodoListPage(),
  '/calculator': (BuildContext context) => const CalculatorPage(),
  '/note': (BuildContext context) => const NotePage(),
};
