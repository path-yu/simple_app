import 'package:flutter/material.dart';
import 'package:simple_app/components/base/tabs.dart';
import 'package:simple_app/page/note_editor_page.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';

final routes = {
  '/': (BuildContext context) => const Tabs(),
  '/todo_list_page': (BuildContext context) => const TodoListPage(),
  '/note': (BuildContext context) => const NotePage(),
  '/create_note_or_editor_page': (BuildContext context) =>
      const NoteEditorPage()
};
