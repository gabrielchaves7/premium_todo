import 'package:flutter/material.dart';
import 'package:premium_todo/design_system/atoms/colors.dart';

enum TabType {
  selected,
  unselected,
}

class DsTab extends StatelessWidget {
  const DsTab({
    super.key,
    required this.text,
    required this.type,
    this.onPressed,
  });
  final String text;
  final TabType type;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        constraints:
            const BoxConstraints(minWidth: double.infinity, minHeight: 40),
        duration: const Duration(seconds: 1),
        color: type == TabType.selected
            ? DsColors.brandColorPrimary
            : DsColors.blueGray400,
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
}
