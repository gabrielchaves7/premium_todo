import 'package:flutter/material.dart';

Future<void> openDialog({
  required BuildContext context,
  required Widget widget,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return widget;
    },
  );
}
