import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localization_cubite/localization_cubit.dart';

class BlocProviderList {
  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<LocalizationCubit>(
        create: (context) => LocalizationCubit()..loadSavedLocale(),
      ),
    ];
  }
}
