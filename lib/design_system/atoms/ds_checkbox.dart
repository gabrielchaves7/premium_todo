import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';

/// Widget that loads an checkbox.
class DsCheckbox extends StatelessWidget {
  ///Creates an DsCheckbox
  const DsCheckbox({
    required this.value,
    this.onChanged,
    super.key,
  });

  /// Wheter this checkbox is checked
  final bool value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(Object context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      checkColor: DsColors.brandColorPrimary,
    );
  }
}
