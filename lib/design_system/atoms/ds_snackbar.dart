import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';

enum DsSnackbarType {
  todoCreateSuccess,
  todoDeleteSuccess,
  todoCreateError,
  todoDeleteError,
  todoGetError,
}

mixin DsSnackBar {
  static SnackBar getSnackBar(DsSnackbarType type) {
    return SnackBar(
      backgroundColor: _getSnackbarColor(type),
      content: Text(_getSnackbarText(type)),
    );
  }

  static String _getSnackbarText(DsSnackbarType type) {
    switch (type) {
      case DsSnackbarType.todoCreateSuccess:
        return 'Todo created successfully!';
      case DsSnackbarType.todoDeleteSuccess:
        return 'Todo deleted successfully!';
      case DsSnackbarType.todoCreateError:
        return 'Error while creating todo.';
      case DsSnackbarType.todoDeleteError:
        return 'Error while deleting todo.';
      case DsSnackbarType.todoGetError:
        return 'Error while geting todos.';
    }
  }

  static Color _getSnackbarColor(DsSnackbarType type) {
    switch (type) {
      case DsSnackbarType.todoCreateSuccess:
        return DsColors.brandColorPrimary;
      case DsSnackbarType.todoDeleteSuccess:
        return DsColors.red700;
      case DsSnackbarType.todoCreateError:
        return DsColors.red700;
      case DsSnackbarType.todoDeleteError:
        return DsColors.red700;
      case DsSnackbarType.todoGetError:
        return DsColors.red700;
    }
  }
}
