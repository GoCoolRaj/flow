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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi`
  String get Hi {
    return Intl.message('Hi', name: 'Hi', desc: '', args: []);
  }

  /// `User name goes against our policy`
  String get user_name_error {
    return Intl.message(
      'User name goes against our policy',
      name: 'user_name_error',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get s_save {
    return Intl.message('Save', name: 's_save', desc: '', args: []);
  }

  /// `How is your experience?`
  String get how_is_your_experience {
    return Intl.message(
      'How is your experience?',
      name: 'how_is_your_experience',
      desc: '',
      args: [],
    );
  }

  /// `Tell us what you think`
  String get tell_us_what_you_think {
    return Intl.message(
      'Tell us what you think',
      name: 'tell_us_what_you_think',
      desc: '',
      args: [],
    );
  }

  /// `Send feedback`
  String get send_feedback {
    return Intl.message(
      'Send feedback',
      name: 'send_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get s_logout_title {
    return Intl.message('Logout', name: 's_logout_title', desc: '', args: []);
  }

  /// `Thanks for your feedback`
  String get thanks_for_feedback {
    return Intl.message(
      'Thanks for your feedback',
      name: 'thanks_for_feedback',
      desc: '',
      args: [],
    );
  }

  /// `We appreciate you taking the time to share.`
  String get thanks_for_feedback_desc {
    return Intl.message(
      'We appreciate you taking the time to share.',
      name: 'thanks_for_feedback_desc',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone.`
  String get delete_account_hint {
    return Intl.message(
      'This action cannot be undone.',
      name: 'delete_account_hint',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get s_yes {
    return Intl.message('Yes', name: 's_yes', desc: '', args: []);
  }

  /// `Okay`
  String get s_okay {
    return Intl.message('Okay', name: 's_okay', desc: '', args: []);
  }

  /// `No`
  String get s_no {
    return Intl.message('No', name: 's_no', desc: '', args: []);
  }

  /// `No favorites yet`
  String get s_favorite_empty_info {
    return Intl.message(
      'No favorites yet',
      name: 's_favorite_empty_info',
      desc: '',
      args: [],
    );
  }

  /// `Save sessions to revisit them here.`
  String get s_favorite_empty_desc {
    return Intl.message(
      'Save sessions to revisit them here.',
      name: 's_favorite_empty_desc',
      desc: '',
      args: [],
    );
  }

  /// `Rename collection`
  String get s_rename_collection {
    return Intl.message(
      'Rename collection',
      name: 's_rename_collection',
      desc: '',
      args: [],
    );
  }

  /// `New collection`
  String get s_new_collection {
    return Intl.message(
      'New collection',
      name: 's_new_collection',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get s_enter_name {
    return Intl.message('Enter name', name: 's_enter_name', desc: '', args: []);
  }

  /// `Create collection`
  String get s_create_collection {
    return Intl.message(
      'Create collection',
      name: 's_create_collection',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get s_delete {
    return Intl.message('Delete', name: 's_delete', desc: '', args: []);
  }

  /// `Cancel`
  String get s_cancel {
    return Intl.message('Cancel', name: 's_cancel', desc: '', args: []);
  }

  /// `Are you sure you want to delete this collection?`
  String get s_collection_delete_message {
    return Intl.message(
      'Are you sure you want to delete this collection?',
      name: 's_collection_delete_message',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get s_rename {
    return Intl.message('Rename', name: 's_rename', desc: '', args: []);
  }

  /// `Delete collection`
  String get s_delete_collection {
    return Intl.message(
      'Delete collection',
      name: 's_delete_collection',
      desc: '',
      args: [],
    );
  }

  /// `Quick save`
  String get s_quick_save {
    return Intl.message('Quick save', name: 's_quick_save', desc: '', args: []);
  }

  /// `Close`
  String get s_close {
    return Intl.message('Close', name: 's_close', desc: '', args: []);
  }

  /// `Change`
  String get s_change {
    return Intl.message('Change', name: 's_change', desc: '', args: []);
  }

  /// `Saved to `
  String get s_saved_to {
    return Intl.message('Saved to ', name: 's_saved_to', desc: '', args: []);
  }

  /// `Removed from `
  String get s_removed_from {
    return Intl.message(
      'Removed from ',
      name: 's_removed_from',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
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
