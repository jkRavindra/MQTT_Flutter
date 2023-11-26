import 'dart:convert';
import 'dart:io';


class StringUtil {
  static AsciiCodec asciiCodec = AsciiCodec();

  /// Returns the given string or the default string if the given string is null
  static String defaultString(String? str, {String defaultStr = ''}) {
    return str ?? defaultStr;
  }

  /// Checks if the given String [s] is null or empty
  static bool isNullOrEmpty(String? s) =>
      (s == null || s.isEmpty) ? true : false;

  /// Checks if the given String [s] is not null or empty
  static bool isNotNullOrEmpty(String? s) => !isNullOrEmpty(s);

  /// Checks if the given String [string] have numbers or not
  static bool isNumber(String string) {
    final pattern = RegExp(r'^[0-9]+$');
    return pattern.hasMatch(string);
  }

  /// Get digit Strings from a given raw string [data]
  /// Example :
  /// getDigits("123abc456) => 123456
  String getDigits(String data) {
    StringBuffer sb = new StringBuffer();
    if (isNumber(data)) {
      return data;
    }
    for (int i = 0; i < data.length; i++) {
      final c = data[i];
      if (isNumber(c)) {
        sb.write(c);
      }
    }
    return sb.toString();
  }

  /// Transfers the given String [s] from camcelCase to upperCaseUnderscore
  static String camelCaseToUpperUnderscore(String s) {
    var sb = StringBuffer();
    var first = true;
    s.runes.forEach((int rune) {
      var char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        sb.write('_');
        sb.write(char.toUpperCase());
      } else {
        first = false;
        sb.write(char.toUpperCase());
      }
    });
    return sb.toString();
  }

  /// Transfers the given String [s] from camcelCase to lowerCaseUnderscore
  static String camelCaseToLowerUnderscore(String s) {
    var sb = StringBuffer();
    var first = true;
    s.runes.forEach((int rune) {
      var char = String.fromCharCode(rune);
      if (isUpperCase(char) && !first) {
        if (char != '_') {
          sb.write('_');
        }
        sb.write(char.toLowerCase());
      } else {
        first = false;
        sb.write(char.toLowerCase());
      }
    });
    return sb.toString();
  }

  /// Checks if the given string [s] is lower case
  static bool isLowerCase(String s) {
    return s == s.toLowerCase();
  }

  /// Checks if the given string [s] is upper case
  static bool isUpperCase(String s) {
    return s == s.toUpperCase();
  }

  /// Checks if the given string [s] contains only ascii chars
  static bool isAscii(String s) {
    try {
      asciiCodec.decode(s.codeUnits);
    } catch (e) {
      return false;
    }
    return true;
  }
  /// Reverse the given string [s]
  static String reverse(String s) {
    return String.fromCharCodes(s.runes.toList().reversed);
  }

  /// Replaces chars of the given String [s] with [replace].
  /// The default value of [replace] is *.
  /// Example :
  /// 1234567890 => *****67890
  /// 1234567890 with begin 2 and end 6 => 12****7890
  static String? hidePartial(String s,
      {int begin = 0, int? end, String replace = '*'}) {
    var buffer = StringBuffer();
    if (s.length <= 1) {
      return null;
    }
    if (end == null) {
      end = (s.length / 2).round();
    } else {
      if (end > s.length) {
        end = s.length;
      }
    }
    for (var i = 0; i < s.length; i++) {
      if (i >= end) {
        buffer.write(String.fromCharCode(s.runes.elementAt(i)));
        continue;
      }
      if (i >= begin) {
        buffer.write(replace);
        continue;
      }
      buffer.write(String.fromCharCode(s.runes.elementAt(i)));
    }
    return buffer.toString();
  }
  /// Add a [char] at a [position] with the given String [s].
  /// Example :
  /// 1234567890 , '-', 3 => 123-4567890
  /// 1234567890 , '-', 3, true => 123-456-789-0
  static String addCharAtPosition(String s, String char, int position,
      {bool repeat = false}) {
    if (!repeat) {
      if (s.length < position) {
        return s;
      }
      var before = s.substring(0, position);
      var after = s.substring(position, s.length);
      return before + char + after;
    } else {
      if (position == 0) {
        return s;
      }
      var buffer = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i != 0 && i % position == 0) {
          buffer.write(char);
        }
        buffer.write(String.fromCharCode(s.runes.elementAt(i)));
      }
      return buffer.toString();
    }
  }

  /// Removes character with [index] from a String [value]
  /// Example:
  /// removeCharAtPosition('flutterr', 8);
  /// returns 'flutter'
  static String removeCharAtPosition(String value, int index) {
    try {
      return value.substring(0, -1 + index) +
          value.substring(index, value.length);
    } catch (e) {
      return value;
    }
  }

  /// Get Readable Amount from given String [amount]
  /// Example:
  /// getReadableAmount("1234") => 1234.00
  /// getReadableAmount("2") => 0.02
  static String getReadableAmount(String amount) {
    String formattedAmount;
    if (amount.length > 2) {
      formattedAmount = amount.substring(0, amount.length - 2);
      formattedAmount += ".";
      formattedAmount += amount.substring(amount.length - 2);
    } else if (amount.length == 2) {
      formattedAmount = "0.";
      formattedAmount += amount;
    } else if (amount.length == 1) {
      formattedAmount = "0.0";
      formattedAmount += amount;
    } else {
      formattedAmount = "0.00";
    }

    return formattedAmount;
  }

}

