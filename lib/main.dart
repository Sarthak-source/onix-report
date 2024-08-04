import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:reports/core/bloc/bloc_provider_list.dart';

import 'core/localization/locale key-value.dart';
import 'core/localization/localization_cubite/localization_cubit.dart';
import 'core/localization/localization_cubite/localization_state.dart';
import 'screens/reports/cubit/reports_cubit.dart';
import 'screens/reports/views/reports_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => PdfFormCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviderList.getProviders(),
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
          buildWhen: (previous, current) => previous != current,
          builder: (_, localizationState) {
            Locale locale = const Locale('ar', 'AR'); // Default locale
            if (localizationState is LocalizationChanged) {
              locale = localizationState.locale;
            }
            return GetMaterialApp(
              title: 'Reports',
              debugShowCheckedModeBanner: false,
              translations: LocaleString(), // Set your translations
              locale: locale, // Set default locale to device locale
              fallbackLocale: const Locale('en', 'US'),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: const PdfFormWidget(),
            );
          }),
    );
  }
}
