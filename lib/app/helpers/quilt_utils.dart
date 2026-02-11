import 'package:flutter/material.dart';

class QuiltUtils {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void showKeyboard() {
    FocusManager.instance.primaryFocus?.requestFocus();
  }

  static String formatCount(int count) {
    if (count >= 1000000) {
      double millions = count / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()}M';
      } else {
        return '${millions.toStringAsFixed(1)}M';
      }
    } else if (count >= 1000) {
      double thousands = count / 1000;
      if (thousands == thousands.toInt()) {
        return '${thousands.toInt()}k';
      } else {
        return '${thousands.toStringAsFixed(1)}k';
      }
    }
    return count.toString();
  }
}
