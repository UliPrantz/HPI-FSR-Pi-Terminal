import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_frontend/presentation/core/format_extensions.dart';

void main() {

  test('Currency formatting test', () {
    const int oneDigit = 1;
    const int twoDigits = 12;
    const int threeDigits = 123;
    const int fourDigits = 1234;

    const String oneDigitResult = '0,01€';
    const String twoDigitsResult = '0,12€';
    const String threeDigitsResult = '1,23€';
    const String fourDigitsResult = '12,34€';

    // Testing the currency formatting extension for positive values
    expect(oneDigit.toEuroString(), oneDigitResult);
    expect(twoDigits.toEuroString(), twoDigitsResult);
    expect(threeDigits.toEuroString(), threeDigitsResult);
    expect(fourDigits.toEuroString(), fourDigitsResult);
    
    // Same as above just for negative values
    expect((-oneDigit).toEuroString(), '-' + oneDigitResult);
    expect((-twoDigits).toEuroString(), '-' + twoDigitsResult);
    expect((-threeDigits).toEuroString(), '-' + threeDigitsResult);
    expect((-fourDigits).toEuroString(), '-' + fourDigitsResult);
  });
}
