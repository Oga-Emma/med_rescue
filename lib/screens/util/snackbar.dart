import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';

import 'loading_snackbar.dart';

class MkSnackBar {
  MkSnackBar.of(BuildContext context)
      : assert(context != null),
        state = Scaffold.of(context);

  MkSnackBar.ofKey(GlobalKey<ScaffoldState> key)
      : assert(key != null),
        state = key.currentState;

  final ScaffoldState state;

  void success(String value, {Duration duration}) {
    hide();
    assert(value != null);
    show(value, backgroundColor: Colors.green);
  }

  void error(String value, {Duration duration}) {
    hide();
    assert(value != null);
    show(value, backgroundColor: Colors.black);
  }

  void show(
      String value, {
        Duration duration,
        Color backgroundColor = primaryColor,
        Color color = Colors.white,
      }) {
    hide();
    assert(value != null);
    state?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          value,
          style: TextStyle(fontSize: 14.0, color: color),
        ),
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }

  void hide() => state?.hideCurrentSnackBar();

  void loading({Widget content}) {
    hide();
    state?.showSnackBar(
      MkLoadingSnackBar(content: content),
    );
  }
}
