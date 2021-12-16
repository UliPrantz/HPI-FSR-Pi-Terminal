extension Formatting on int {
  String toEuroString() {
    String balanceString = abs().toString().padLeft(4, '0');
    int strLen = balanceString.length;
    String sign = isNegative ? '-' : '';
    String euros = balanceString.substring(0, strLen-2);
    String cents = balanceString.substring(strLen-2, strLen);
    return "$sign$euros,$cents€";
  }
}