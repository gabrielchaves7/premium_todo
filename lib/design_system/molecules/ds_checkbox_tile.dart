import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/ds_checkbox.dart';

/// Widget that loads a checkbox with a text on the right.
class DsCheckboxTile extends StatelessWidget {
  ///Creates an DsCheckboxTile
  const DsCheckboxTile({
    required this.title,
    required this.value,
    this.onChanged,
    this.trailing,
    super.key,
  });

  /// The text to display next to the checkbox.
  final String title;

  /// Wheter this checkbox is checked
  final bool value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?>? onChanged;

  ///A widget to display after the title.
  final Widget? trailing;

  @override
  Widget build(Object context) {
    return ListTile(
      title: Text(title),
      leading: DsCheckbox(
        value: value,
        onChanged: onChanged,
      ),
      trailing: trailing,
    );
  }
}
