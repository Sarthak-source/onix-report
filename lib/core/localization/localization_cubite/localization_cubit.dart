import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:reports/core/localization/localization_cubite/localization_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInitial());

  void changeLocale(String locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the language code to SharedPreferences
    await prefs.setString('language_code', locale);

    var localeObj = Locale(locale);
    Get.updateLocale(localeObj);
    emit(LocalizationChanged(localeObj));
  }

  void loadSavedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      var localeObj = Locale(languageCode);
      Get.updateLocale(localeObj);
      emit(LocalizationChanged(localeObj));
    }
  }
}
