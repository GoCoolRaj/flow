import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final Color cursorColor;
  final TextEditingController controller;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? promptCallback;
  final int? maxWords;
  final int? maxCharacters;
  final int minLines;
  final int maxLines;
  final int maxCollapsed;
  final String? hintText;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final bool? allowEmojis;

  const FeedbackTextField({
    super.key,
    this.textStyle,
    required this.cursorColor,
    required this.controller,
    this.onTextChanged,
    this.promptCallback,
    this.maxWords,
    this.maxCharacters,
    required this.minLines,
    required this.maxLines,
    required this.maxCollapsed,
    this.hintText,
    this.hintStyle,
    this.focusNode,
    this.allowEmojis = false,
  });

  @override
  PromptTextFieldState createState() => PromptTextFieldState();
}

class PromptTextFieldState extends State<FeedbackTextField> {
  Timer? _pauseTimer;
  Timer? _debounce;
  late int _currentMaxLines;

  @override
  void initState() {
    super.initState();
    _updateMaxLines();
    widget.focusNode?.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _updateMaxLines();
    });
  }

  void _updateMaxLines() {
    final isFocused = widget.focusNode?.hasFocus ?? false;

    if (isFocused) {
      _currentMaxLines = widget.maxLines;
    } else {
      if (widget.maxCollapsed == -1) {
        final typedLines = widget.controller.text.split('\n').length;
        _currentMaxLines = typedLines.clamp(widget.minLines, widget.maxLines);
      } else {
        _currentMaxLines = widget.maxCollapsed;
      }
    }
  }

  void _onTextChanged(String value) {
    _pauseTimer?.cancel();
    _debounce?.cancel();

    if (widget.maxWords != null) {
      final wordCount = value.trim().split(RegExp(r'\s+')).length;
      if (wordCount > widget.maxWords!) {
        widget.controller.text =
            value.trimRight().substring(0, value.lastIndexOf(' '));
        widget.controller.selection =
            TextSelection.collapsed(offset: widget.controller.text.length);
      }
    }

    if (widget.maxCharacters != null && value.length > widget.maxCharacters!) {
      widget.controller.text = value.substring(0, widget.maxCharacters!);
      widget.controller.selection =
          TextSelection.collapsed(offset: widget.maxCharacters!);
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onTextChanged?.call(widget.controller.text);
    });

    _pauseTimer = Timer(const Duration(seconds: 3), () {
      widget.promptCallback?.call(value);
    });

    if (widget.maxCollapsed == -1 && !(widget.focusNode?.hasFocus ?? false)) {
      setState(() {
        final typedLines = widget.controller.text.split('\n').length;
        _currentMaxLines = typedLines.clamp(widget.minLines, widget.maxLines);
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _pauseTimer?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      minLines: widget.minLines,
      maxLines: _currentMaxLines,
      style: widget.textStyle,
      focusNode: widget.focusNode ?? FocusNode(),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: _onTextChanged,
      inputFormatters: widget.allowEmojis == true
          ? []
          : [
              FilteringTextInputFormatter.deny(
                RegExp(r'[^\x00-\x7F“”‘’"]+'),
              ),
            ],
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
      ),
    );
  }
}
