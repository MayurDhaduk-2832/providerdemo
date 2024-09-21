import 'package:flutter/material.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'demo_localization.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String HINDI ="hi";
const String MARATHI ="mr";
const String BANGALI ="bn";
const String TAMIL ="ta";
const String TELUGU ="te";
const String GUJARATI ="gu";
const String KANNADA ="kn";
const String MALAYALAM ="ml";
const String SPANISH  ="es";
const String PERSIAN ="fa";
const String ARABIC ="ar";
const String NEPALI ="ne";
const String FRENCH ="fr";
const String PUNJABI  ="pa";
const String PORTUGUESE ="pt";
const String PASHTO ="ps";
const String ITALIAN ="it";
const String DUTCH ="nl";
const String INDONESIAN ="id";


Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  Utils.currentLanguage = languageCode;
  return _locale(languageCode);
}



Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case HINDI:
      return Locale(HINDI, "IN");
      case MARATHI:
      return Locale(MARATHI, "IN");
      case BANGALI:
      return Locale(BANGALI, "IN");
      case TAMIL:
      return Locale(TAMIL, "IN");
      case TELUGU:
      return Locale(TELUGU, "IN");
      case GUJARATI:
      return Locale(GUJARATI, "IN");
      case KANNADA:
      return Locale(KANNADA, "IN");
      case MALAYALAM:
      return Locale(MALAYALAM, "IN");
      case SPANISH:
      return Locale(SPANISH, "SPA");
      case PERSIAN:
      return Locale(PERSIAN, "PER");
      case ARABIC:
      return Locale(ARABIC, "ARA");
      case NEPALI:
      return Locale(NEPALI, "NEP");
      case FRENCH:
      return Locale(FRENCH, "FRE");
      case PUNJABI:
      return Locale(PUNJABI, "IN");
      case PORTUGUESE:
      return Locale(PORTUGUESE, "POR");
      case PASHTO:
      return Locale(PASHTO, "PUS");
      case ITALIAN:
      return Locale(ITALIAN, "ITA");
      case DUTCH:
      return Locale(DUTCH, "DUT");
      case INDONESIAN:
      return Locale(INDONESIAN, "IND");

    default:
      return Locale(ENGLISH, 'US');
  }
}

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)?.translate(key);
}
