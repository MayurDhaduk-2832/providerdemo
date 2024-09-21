import 'dart:convert';

List<CurrencyModel> currencyModelFromJson(String str) => List<CurrencyModel>.from(json.decode(str).map((x) => CurrencyModel.fromJson(x)));


class CurrencyModel {
  CurrencyModel({
    this.symbol,
    this.name,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
    this.code,
    this.namePlural,
  });

  String symbol;
  String name;
  String symbolNative;
  int decimalDigits;
  double rounding;
  String code;
  String namePlural;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
    symbol: json["symbol"],
    name: json["name"],
    symbolNative: json["symbol_native"],
    decimalDigits: json["decimal_digits"],
    rounding: json["rounding"].toDouble(),
    code: json["code"],
    namePlural: json["name_plural"],
  );
}
