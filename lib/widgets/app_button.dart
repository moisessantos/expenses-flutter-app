import 'package:expenses_app/constants.dart';
import 'package:expenses_app/widgets/small_spacing.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;
  final Widget? leading;
  final Color? textColor;
  final Color? backgroundColor;

  const AppButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.padding = kScreenPadding,
      this.leading,
      this.textColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final borderRadius = BorderRadius.circular(28);

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: enabled
                ? (backgroundColor != null
                    ? LinearGradient(
                        colors: [
                          backgroundColor!.withValues(alpha: 0.95),
                          backgroundColor!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ))
                : LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade300]),
            borderRadius: borderRadius,
            boxShadow: [
              if (enabled)
                BoxShadow(
                  color:
                      (backgroundColor ?? Theme.of(context).colorScheme.primary)
                          .withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor ?? Colors.white),
                  child: leading!,
                ),
                const SmallSpacing(),
              ],
              DefaultTextStyle(
                style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
