import 'package:clinic_manager/core/utils/currencies.dart';
import 'package:clinic_manager/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  test('formats money from minor units', () {
    final formatted = formatMoneyMinor(
      1234,
      currencyCode: 'USD',
      localeTag: 'en',
    );
    expect(formatted, contains('12.34'));
    expect(formatted, contains(r'$'));
  });

  test('falls back to a known currency for unknown codes', () {
    expect(currencyFor('SYP').code, 'SYP');
    expect(currencyFor('XYZ').code, 'USD');
  });

  test('formats long and short dates', () {
    final date = DateTime(2026, 11, 13, 9, 30);
    expect(formatLongDate(date, 'en'), contains('November'));
    expect(formatShortDate(date, 'en'), contains('2026'));
    expect(formatTime(date, 'en'), contains('9:30'));
  });
}
