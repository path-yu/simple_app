// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addTodo": MessageLookupByLibrary.simpleMessage("add todo"),
        "calculator": MessageLookupByLibrary.simpleMessage("calculator"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "complete": MessageLookupByLibrary.simpleMessage("have finished"),
        "confirm": MessageLookupByLibrary.simpleMessage("confirm"),
        "delete": MessageLookupByLibrary.simpleMessage("delete"),
        "deleteTodoMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure to delete the current todo"),
        "dialogDeleteMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete"),
        "hint": MessageLookupByLibrary.simpleMessage("hint"),
        "nightMode": MessageLookupByLibrary.simpleMessage("night mode"),
        "noNotificationPermission": MessageLookupByLibrary.simpleMessage(
            "No notification permission, go to the settings interface to set the permission?"),
        "notEmpty": MessageLookupByLibrary.simpleMessage("can not be empty"),
        "note": MessageLookupByLibrary.simpleMessage("note"),
        "setting": MessageLookupByLibrary.simpleMessage("setting"),
        "switchLanguage":
            MessageLookupByLibrary.simpleMessage("switch language to english"),
        "todoList": MessageLookupByLibrary.simpleMessage("todoList"),
        "toolKit": MessageLookupByLibrary.simpleMessage("tool kit"),
        "translate": MessageLookupByLibrary.simpleMessage("translate"),
        "underway": MessageLookupByLibrary.simpleMessage("underway"),
        "weatherQuery": MessageLookupByLibrary.simpleMessage("weather query")
      };
}
