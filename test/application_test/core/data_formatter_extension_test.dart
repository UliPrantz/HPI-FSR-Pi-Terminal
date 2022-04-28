import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_frontend/application/core/data_formatter_extension.dart';

void main() {
  test('Data Formatter Extenstion Test', () {
    const String three = "123";
    const String four = "1234";
    const String five = "12345";

    const String replacementTwo = "..";
    const String replacementThree = "...";

    expect(() {
      five.limitCharacters(-1, "overflowReplacement");
    }, throwsAssertionError);
    expect(() {
      five.limitCharacters(1, "1");
    }, throwsAssertionError);
    expect(() {
      five.limitCharacters(1, "12");
    }, throwsAssertionError);

    expect(three.limitCharacters(3, replacementTwo), "123");
    expect(four.limitCharacters(3, replacementTwo), "1..");
    expect(five.limitCharacters(3, replacementTwo), "1..");

    expect(five.limitCharacters(4, replacementThree), "1...");
  });
}