import 'dart:ui';

abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class LocalizationChanged extends LocalizationState {
  final Locale locale;
  LocalizationChanged(this.locale);
}
