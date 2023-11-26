import 'dart:math';

class MathUtils {

  /// Method is used to get manimum value from given two values.
  String getMin(String firstValue, String secondValue) {
    if (firstValue == null || firstValue == '') {
      throw Exception('Value can not be empty or null');
    }
    if (secondValue == null || secondValue == '') {
      throw Exception('Value can not be empty or null');
    }
    int firstIntValue = int.parse(firstValue);
    int secondIntValue = int.parse(secondValue);
    String minValue;
    if(firstIntValue <= secondIntValue){
      minValue = firstIntValue.toString();
    }else{
      minValue = secondValue.toString();
    }
    return minValue;

  }

  /// Method is used to get maximum value from given two values.
  String getMax(String firstValue, String secondValue) {
    if (firstValue == null || firstValue == '') {
      throw Exception('Value can not be empty or null');
    }
    if (secondValue == null || secondValue == '') {
      throw Exception('Value can not be empty or null');
    }
    int firstIntValue = int.parse(firstValue);
    int secondIntValue = int.parse(secondValue);
    String minValue;
    if(firstIntValue >= secondIntValue){
      minValue = firstIntValue.toString();
    }else{
      minValue = secondValue.toString();
    }
    return minValue;

  }

  /// Rounds the give double [value] to the given [decimals].
  static double round(double value, int decimals) =>
      (value * pow(10, decimals)).round() / pow(10, decimals);

  /// Generates random between be [min] and [max]
  static int getRandomNumber({int min = 0, int max = 2 ^ 32}) =>
      min + Random().nextInt(max - min);

  /// Converts [x] to a double and returns the logarithm with [base] of the value.
  static double logBase(num x, num base) {
    return log(x) / log(base);
  }

  /// Return the binary logarithm of [x], that is, the logarithm with base 2.
  static double log2(num x) {
    return logBase(x, 2);
  }

  /// Return the common logarithm of [x], that is, the logarithm with base 10.
  static double log10(num x) {
    return logBase(x, 10);
  }

}