import 'package:flutter/material.dart';

class AnimatedSwitcherIcon extends StatelessWidget {
  final Widget? icon;
  final bool isSelected;

  const AnimatedSwitcherIcon({
    super.key,
    this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: !isSelected ? 0 : 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return isSelected
            ? ScaleTransition(
                scale: animation,
                child: child,
              )
            : child;
      },
      child: Container(
        key: ValueKey<bool>(isSelected),
        child: icon,
      ),
    );
  }
}
