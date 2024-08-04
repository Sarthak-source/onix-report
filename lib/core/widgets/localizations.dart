
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localization_cubite/localization_cubit.dart';

class LanguageMenu extends StatelessWidget {
  final bool showFull;
  const LanguageMenu({super.key, this.showFull = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        context.read<LocalizationCubit>().changeLocale(value);
      },
      icon: Row(
        children: [
          const Icon(Icons.language),
          showFull ? const SizedBox(width: 10) : const SizedBox.shrink(),
          showFull
              ?  const Text('English',
                  style: TextStyle(fontSize: 12))
              : const SizedBox.shrink(),
          showFull ? const SizedBox(width: 10) : const SizedBox.shrink(),
          showFull
              ? const Icon(Icons.download)
              : const SizedBox.shrink()
        ],
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          const PopupMenuItem(
            value: 'ar',
            child: Text('Arabic'),
          ),
        ];
      },
    );
  }
}
