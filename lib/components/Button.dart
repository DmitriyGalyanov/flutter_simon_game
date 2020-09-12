import 'package:flutter/material.dart';

class Button extends StatelessWidget { //TODO: edit Button view
  final String label;
  final Function handleTap;
  final bool isDisabled;
  const Button({
    @required this.label,
    this.handleTap,
    this.isDisabled = false});
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(label),
      onPressed: isDisabled ? null : handleTap,
    );
  }
}
