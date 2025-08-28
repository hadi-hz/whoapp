import 'package:get/get.dart';
import 'package:test3/core/lang/english_lang.dart';
import 'package:test3/core/lang/france_lang.dart';
import 'package:test3/core/lang/itly_lang.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'fr': fr, 'it': it};
}