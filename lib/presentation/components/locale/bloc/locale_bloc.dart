import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_state.dart';

class LocaleBloc extends Cubit<LocaleState> {
  LocaleBloc() : super(LocaleState(locale: _getSystemLocale()));

  static Locale _getSystemLocale() {
    final localeList = WidgetsBinding.instance.platformDispatcher.locales;
    return localeList.isNotEmpty ? localeList.first : const Locale('en', 'US');
  }

  void setLocale(Locale locale) {
    emit(LocaleState(locale: locale));
  }
}
