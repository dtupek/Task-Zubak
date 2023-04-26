import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton = LoadingIndicatorDialog._internal();
  factory LoadingIndicatorDialog() => _singleton;
  LoadingIndicatorDialog._internal();

  bool isDisplayed = false;

  void show(final BuildContext context) {
    if (isDisplayed) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        isDisplayed = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void dismiss(final BuildContext context) {
    if (isDisplayed) {
      Navigator.of(context).pop();
      isDisplayed = false;
    }
  }
}
