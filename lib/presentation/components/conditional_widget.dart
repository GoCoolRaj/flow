import 'package:flutter/widgets.dart';

class ConditionalWidget extends StatelessWidget {
  static Key parentWidgetKey = UniqueKey();

  final bool condition;
  final Widget onTrue;
  final Widget onFalse;
  final bool isAnimated;

  const ConditionalWidget({
    super.key,
    required this.condition,
    required this.onTrue,
    required this.onFalse,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isAnimated) {
      return AnimatedSwitcher(
        key: parentWidgetKey,
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: condition ? onTrue : onFalse,
      );
    } else {
      return condition ? onTrue : onFalse;
    }
  }
}
