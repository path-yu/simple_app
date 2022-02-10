// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tool kit`
  String get toolKit {
    return Intl.message(
      'Tool kit',
      name: 'toolKit',
      desc: '',
      args: [],
    );
  }

  /// `setting`
  String get setting {
    return Intl.message(
      'setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `translate`
  String get translate {
    return Intl.message(
      'translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Weather query`
  String get weatherQuery {
    return Intl.message(
      'Weather query',
      name: 'weatherQuery',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get note {
    return Intl.message(
      'note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `calculator`
  String get calculator {
    return Intl.message(
      'calculator',
      name: 'calculator',
      desc: '',
      args: [],
    );
  }

  /// `Todo list`
  String get todoList {
    return Intl.message(
      'Todo list',
      name: 'todoList',
      desc: '',
      args: [],
    );
  }

  /// `Night mode`
  String get nightMode {
    return Intl.message(
      'Night mode',
      name: 'nightMode',
      desc: '',
      args: [],
    );
  }

  /// `Switch language to english`
  String get switchLanguage {
    return Intl.message(
      'Switch language to english',
      name: 'switchLanguage',
      desc: '',
      args: [],
    );
  }

  /// `hint`
  String get hint {
    return Intl.message(
      'hint',
      name: 'hint',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get dialogDeleteMessage {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'dialogDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Add todo`
  String get addTodo {
    return Intl.message(
      'Add todo',
      name: 'addTodo',
      desc: '',
      args: [],
    );
  }

  /// `You added a new todo!`
  String get addTodoMessage {
    return Intl.message(
      'You added a new todo!',
      name: 'addTodoMessage',
      desc: '',
      args: [],
    );
  }

  /// `This is an announcement.`
  String get todoNoticeTitle {
    return Intl.message(
      'This is an announcement.',
      name: 'todoNoticeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Today's todo has been completed, please make persistent efforts.`
  String get todoCompleteMessage {
    return Intl.message(
      'Today\'s todo has been completed, please make persistent efforts.',
      name: 'todoCompleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `No notification permission, go to the settings interface to set the permission?`
  String get noNotificationPermission {
    return Intl.message(
      'No notification permission, go to the settings interface to set the permission?',
      name: 'noNotificationPermission',
      desc: '',
      args: [],
    );
  }

  /// `underway`
  String get underway {
    return Intl.message(
      'underway',
      name: 'underway',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete the current todo?`
  String get deleteTodoMessage {
    return Intl.message(
      'Are you sure to delete the current todo?',
      name: 'deleteTodoMessage',
      desc: '',
      args: [],
    );
  }

  /// `Have finished`
  String get complete {
    return Intl.message(
      'Have finished',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Can not be empty`
  String get notEmpty {
    return Intl.message(
      'Can not be empty',
      name: 'notEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit the App`
  String get tryAgainExitApp {
    return Intl.message(
      'Press again to exit the App',
      name: 'tryAgainExitApp',
      desc: '',
      args: [],
    );
  }

  /// `No development`
  String get noDevelopment {
    return Intl.message(
      'No development',
      name: 'noDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Search note`
  String get searchNote {
    return Intl.message(
      'Search note',
      name: 'searchNote',
      desc: '',
      args: [],
    );
  }

  /// `Editor note`
  String get editorNote {
    return Intl.message(
      'Editor note',
      name: 'editorNote',
      desc: '',
      args: [],
    );
  }

  /// `Create note`
  String get createNote {
    return Intl.message(
      'Create note',
      name: 'createNote',
      desc: '',
      args: [],
    );
  }

  /// `title`
  String get title {
    return Intl.message(
      'title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `You haven't added a note yet. Please click the button to add a note!`
  String get notNoteMessage {
    return Intl.message(
      'You haven\'t added a note yet. Please click the button to add a note!',
      name: 'notNoteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately, no data was found!`
  String get notSearchNoteMessage {
    return Intl.message(
      'Unfortunately, no data was found!',
      name: 'notSearchNoteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Title or content cannot be empty`
  String get titleAndNoteNotNullMessage {
    return Intl.message(
      'Title or content cannot be empty',
      name: 'titleAndNoteNotNullMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update successful`
  String get updateSuccess {
    return Intl.message(
      'Update successful',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get updateFail {
    return Intl.message(
      'Update failed',
      name: 'updateFail',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully`
  String get saveSuccess {
    return Intl.message(
      'Saved successfully',
      name: 'saveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Saved failed`
  String get saveFail {
    return Intl.message(
      'Saved failed',
      name: 'saveFail',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
