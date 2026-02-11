import 'package:flutter/material.dart';

class RouterScope extends StatefulWidget {
  final Widget? child;
  final VoidCallback inject;
  final VoidCallback dispose;

  const RouterScope({
    super.key,
    this.child,
    required this.inject,
    required this.dispose,
  });

  @override
  State<RouterScope> createState() => _RouterScopeState();
}

class _RouterScopeState extends State<RouterScope> {
  @override
  void initState() {
    super.initState();
    widget.inject();
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
