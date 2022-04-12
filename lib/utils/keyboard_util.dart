import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}
