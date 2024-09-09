import 'dart:math';

import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class UniqueNumberGenerator {
  // A set to store the generated numbers.
  final Set<int> _generatedNumbers = <int>{};

  // The random number generator.
  final Random _random = Random();

  int generateUniqueNumber() {
    while (true) {
      final int number = 1000 + _random.nextInt(9000); // Generates a random number between 1000 and 9999.

      // If the number hasn't been generated before, add it to the set and return it.
      if (_generatedNumbers.add(number)) {
        return number;
      }

      // If we've already generated all possible 4-digit numbers, return null.
      if (_generatedNumbers.length == 9000) {
        return 0;
      }
    }
  }
}

class NumberRangeInputFormatter extends TextInputFormatter {
  RegExp regExp = RegExp(r'^(0?([0-9]|1[0-9]|2[0-4])?)$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || regExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class NumberRangeInputFormatter2 extends TextInputFormatter {
  RegExp regExp = RegExp(r'^(0?[0-9]|[1-5][0-9]|60)$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || regExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

userAge(DateTime currentDate, DateTime birthDate) {
  Duration parse = currentDate.difference(birthDate).abs();
  return "${parse.inDays~/360} Years";
  //return "${parse.inDays~/360} Years ${((parse.inDays%360)~/30)} Month ${(parse.inDays%360)%30} Days";
}

String obscureString(String input) {
  if (input.length <= 3) {
    return input;
  } else {
    String obscured = '';
    for (int i = 0; i < input.length - 3; i++) {
      obscured += '*';
    }
    obscured += input.substring(input.length - 3);
    return obscured;
  }
}

class MonthFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, allow it (deletion)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-numeric characters
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    int? number = int.tryParse(cleanedText);

    if (number == null || number < 1 || number > 12) {
      // Invalid input or out-of-range, return the old value
      return oldValue;
    }

    // Valid input, return the new value with the cleaned number
    return newValue.copyWith(text: cleanedText);
  }
}

class DayFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, allow it (deletion)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-numeric characters
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    int? number = int.tryParse(cleanedText);

    if (number == null || number < 1 || number > 31) {
      // Invalid input or out-of-range, return the old value
      return oldValue;
    }

    // Valid input, return the new value with the cleaned number
    return newValue.copyWith(text: cleanedText);
  }
}

class YearFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, allow it (deletion)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-numeric characters
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    int? number = int.tryParse(cleanedText);

    if (number == null || number < 1959 || number > 2023) {
      // Invalid input or out-of-range, return the old value
      return oldValue;
    }

    // Valid input, return the new value with the cleaned number
    return newValue.copyWith(text: cleanedText);


  }
}
