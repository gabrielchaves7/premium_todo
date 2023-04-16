import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';

enum TabType {
  selected,
  unselected,
}

enum TabBorderStyle {
  leftRounded,
  rightRounded,
  none,
}

class DsTab extends StatelessWidget {
  const DsTab({
    super.key,
    required this.text,
    required this.type,
    this.onPressed,
    this.tabBorderStyle = TabBorderStyle.none,
  });
  final String text;
  final TabType type;
  final void Function()? onPressed;
  final TabBorderStyle tabBorderStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: _getTabBorderRadius(),
          color: type == TabType.selected
              ? DsColors.brandColorPrimary
              : DsColors.blueGray400,
        ),
        constraints:
            const BoxConstraints(minWidth: double.infinity, minHeight: 40),
        duration: const Duration(seconds: 1),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: type == TabType.selected
                  ? DsColors.neutralWhite
                  : DsColors.blueGray50,
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius? _getTabBorderRadius() {
    BorderRadius? borderRadius;
    if (tabBorderStyle == TabBorderStyle.leftRounded) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(40),
        bottomLeft: Radius.circular(40),
      );
    } else if (tabBorderStyle == TabBorderStyle.rightRounded) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      );
    }

    return borderRadius;
  }
}
