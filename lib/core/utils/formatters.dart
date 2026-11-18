import 'package:intl/intl.dart';

import 'currencies.dart';

String formatMoneyMinor(
  int minor, {
  required String currencyCode,
  required String localeTag,
}) {
  final currency = currencyFor(currencyCode);
  return NumberFormat.currency(
    locale: localeTag,
    symbol: currency.symbol,
    decimalDigits: 2,
  ).format(minor / 100);
}

String formatLongDate(DateTime date, String localeTag) =>
    DateFormat.yMMMMEEEEd(localeTag).format(date);

String formatShortDate(DateTime date, String localeTag) =>
    DateFormat.yMMMd(localeTag).format(date);

String formatTime(DateTime date, String localeTag) =>
    DateFormat.jm(localeTag).format(date);
