import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  static const Locale english = Locale('en');
  final Locale locale;

  const LocaleState({
    this.locale = english,
  });

  @override
  List<Object> get props => [locale];
}
