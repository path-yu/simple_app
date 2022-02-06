import 'package:simple_app/components/base/tabs.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';

final routes = {
  '/': (context) => const Tabs(),
  'todo_list': (context) => const TodoListPage(),
  '/note': (context) => const NotePage()
};
