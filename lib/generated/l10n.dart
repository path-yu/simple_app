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

  /// `tool kit`
  String get toolKit {
    return Intl.message(
      'tool kit',
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

  /// `weather query`
  String get weatherQuery {
    return Intl.message(
      'weather query',
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

  /// `todoList`
  String get todoList {
    return Intl.message(
      'todoList',
      name: 'todoList',
      desc: '',
      args: [],
    );
  }

  /// `night mode`
  String get nightMode {
    return Intl.message(
      'night mode',
      name: 'nightMode',
      desc: '',
      args: [],
    );
  }

  /// `switch language to english`
  String get switchLanguage {
    return Intl.message(
      'switch language to english',
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

  /// `Are you sure you want to delete`
  String get dialogDeleteMessage {
    return Intl.message(
      'Are you sure you want to delete',
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

  /// `add todo`
  String get addTodo {
    return Intl.message(
      'add todo',
      name: 'addTodo',
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
