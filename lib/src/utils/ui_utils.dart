import 'package:flutter/material.dart';

void showOK(String message, BuildContext scaffoldContext) {
  _showSnackBar(message, scaffoldContext, Colors.green);
}

void showError(String message, BuildContext scaffoldContext) {
  _showSnackBar(message, scaffoldContext, Colors.red);
}

void _showSnackBar(
    String message, BuildContext scaffoldContext, Color background) {
  SnackBar _snackBarr = SnackBar(
    content: Text(message),
    backgroundColor: background,
    behavior: SnackBarBehavior.floating,
  );
  Scaffold.of(scaffoldContext).removeCurrentSnackBar();
  Scaffold.of(scaffoldContext).showSnackBar(_snackBarr);
}
