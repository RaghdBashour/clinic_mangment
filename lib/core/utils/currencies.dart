class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.nameEn,
    required this.nameAr,
  });

  final String code;
  final String symbol;
  final String nameEn;
  final String nameAr;

  String label(bool arabic) => arabic ? '$nameAr ($code)' : '$nameEn ($code)';
}

const supportedCurrencies = <CurrencyOption>[
  CurrencyOption(
    code: 'SYP',
    symbol: 'ل.س',
    nameEn: 'Syrian pound',
    nameAr: 'ليرة سورية',
  ),
  CurrencyOption(
    code: 'USD',
    symbol: r'$',
    nameEn: 'US dollar',
    nameAr: 'دولار أمريكي',
  ),
  CurrencyOption(code: 'EUR', symbol: '€', nameEn: 'Euro', nameAr: 'يورو'),
  CurrencyOption(
    code: 'SAR',
    symbol: 'ر.س',
    nameEn: 'Saudi riyal',
    nameAr: 'ريال سعودي',
  ),
  CurrencyOption(
    code: 'AED',
    symbol: 'د.إ',
    nameEn: 'UAE dirham',
    nameAr: 'درهم إماراتي',
  ),
  CurrencyOption(
    code: 'EGP',
    symbol: 'ج.م',
    nameEn: 'Egyptian pound',
    nameAr: 'جنيه مصري',
  ),
  CurrencyOption(
    code: 'JOD',
    symbol: 'د.أ',
    nameEn: 'Jordanian dinar',
    nameAr: 'دينار أردني',
  ),
  CurrencyOption(
    code: 'IQD',
    symbol: 'ع.د',
    nameEn: 'Iraqi dinar',
    nameAr: 'دينار عراقي',
  ),
  CurrencyOption(
    code: 'LBP',
    symbol: 'ل.ل',
    nameEn: 'Lebanese pound',
    nameAr: 'ليرة لبنانية',
  ),
  CurrencyOption(
    code: 'TRY',
    symbol: '₺',
    nameEn: 'Turkish lira',
    nameAr: 'ليرة تركية',
  ),
];

CurrencyOption currencyFor(String code) {
  for (final currency in supportedCurrencies) {
    if (currency.code == code) return currency;
  }
  return supportedCurrencies[1];
}
