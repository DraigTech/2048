import 'package:flutter/material.dart';

/// A widget that displays a score.
class GameButtonWidget extends StatelessWidget {
  /// Creates a [GameButtonWidget] instance.
  const GameButtonWidget({
    required this.size,
    required this.icon,
    required this.onPressed,
    this.borderRadius = 10,
    super.key,
  });

  /// The size of the widget.
  final Size size;

  /// The icon of the widget.
  final IconData icon;

  /// The on pressed on the widget.
  final void Function()? onPressed;

  /// The border radius on the widget.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(
        canRequestFocus: false,
        descendantsAreFocusable: false,
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          color: Colors.blueGrey,
        ),
        width: size.width,
        height: size.height,
        child: InkWell(
          onTap: onPressed,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
