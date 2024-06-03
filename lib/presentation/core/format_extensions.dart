extension Formatting on int {
  String toEuroString() {
    final int absolutCashValue = abs();

    int cents = absolutCashValue % 100;
    int euros = absolutCashValue ~/ 100;
    String sign = isNegative ? '-' : '';

    return "$sign$euros,${cents.toString().padLeft(2, '0')} €";
  }
}
