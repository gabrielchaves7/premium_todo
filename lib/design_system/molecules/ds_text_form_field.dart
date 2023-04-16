import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';
import 'package:premium_todo/design_system/atoms/spacing.dart';
import 'package:premium_todo/design_system/atoms/text_styles.dart';

/// Default text form field
class DSTextField extends StatelessWidget {
  ///
  const DSTextField({
    this.label,
    this.leadingIconPath,
    this.textInputType,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
    this.maxLines = 1,
    this.hintText,
    super.key,
  });

  /// Label displayed on top of the input field
  final String? label;

  /// leading icon
  final String? leadingIconPath;

  /// The type of information for which to optimize the text input control
  final TextInputType? textInputType;

  /// Optional input validation and formatting overrides
  final List<TextInputFormatter>? inputFormatters;

  /// Error text to be displayed bellow the input
  final String? errorText;

  /// Called when user change the text field value
  final ValueChanged<String>? onChanged;

  /// Max lines of the text input
  final int maxLines;

  /// Hint to show inside the input
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 320,
        minWidth: 232,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => onChanged?.call(value.replaceAll(',', '')),
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            style: DsTextStyles.headingSmall.merge(
              TextStyle(
                color: hasError ? DsColors.red700 : DsColors.blueGray600,
              ),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: DsSpacing.xs, horizontal: DsSpacing.x),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 24,
                maxWidth: 40,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: DsColors.blueGray50),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: DsColors.brandColorPrimary),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: DsColors.red700),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: DsColors.red700),
              ),
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}
