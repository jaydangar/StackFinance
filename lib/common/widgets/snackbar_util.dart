/*
* Shows snackbar with provided widget...
*/
import 'package:flutter/material.dart';

class SnackbarWidget {
  static void showSnackbar(
      {@required Widget content, @required BuildContext context}) {
    Scaffold.of(context).showSnackBar(SnackBar(content: content));
  }
}
