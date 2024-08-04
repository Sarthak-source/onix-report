import 'package:get/get.dart';
import 'langs/ar_lang.dart';
import 'langs/en_lang.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enLang,
        'ar_EG': arLang
      };
}