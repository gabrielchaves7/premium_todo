import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';
import 'package:premium_todo/design_system/atoms/text_styles.dart';

/// Type of the button, can be primary or secondary
enum DsOutlinedButtonType {
  /// background with the primary color without borders
  primary,

  /// borders with the primary color and no background color
  secondary,
}

/// Widget that loads the svg logo.
class DsOutlinedButton extends StatelessWidget {
  ///Creates an DsOutlinedButton
  const DsOutlinedButton({
    required this.child,
    required this.onPressed,
    this.buttonType = DsOutlinedButtonType.primary,
    this.enabled = true,
    super.key,
  });

  /// button content
  final Widget child;

  /// callback to be called when button is pressed
  final VoidCallback? onPressed;

  /// will define the style of the button. Can be primary or secondary
  final DsOutlinedButtonType buttonType;

  /// If false user wont be able to click at the button
  final bool enabled;

  @override
  Widget build(Object context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 40,
        maxHeight: 40,
        maxWidth: 320,
        minWidth: 320,
      ),
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.resolveWith<Color>(_getBackgroundColor),
          side: MaterialStateProperty.all<BorderSide?>(
            _getBorderSide(),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            DsTextStyles.button,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            _getForegroundColor(),
          ),
        ),
        child: child,
      ),
    );
  }

  Color _getBackgroundColor(Set<MaterialState> states) {
    var color = DsColors.neutralWhite;
    if (buttonType == DsOutlinedButtonType.primary) {
      if (states.contains(MaterialState.disabled)) {
        color = DsColors.brandColorPrimaryLight;
      } else {
        color = DsColors.brandColorPrimary;
      }
    }

    return color;
  }

  BorderSide? _getBorderSide() {
    BorderSide? borderSide;
    if (buttonType == DsOutlinedButtonType.secondary) {
      borderSide =
          const BorderSide(width: 2, color: DsColors.brandColorPrimary);
    }

    return borderSide;
  }

  Color _getForegroundColor() {
    var color = DsColors.neutralWhite;
    if (buttonType == DsOutlinedButtonType.secondary) {
      color = DsColors.brandColorPrimary;
    }

    return color;
  }
}
