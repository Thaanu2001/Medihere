import 'package:flutter/material.dart';

dismissKeyboard(context) {
  //* Dismiss The Keyboard when pressing the button ---------------------------------------------------------------------
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
