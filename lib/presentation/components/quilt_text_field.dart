import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';

enum TextFieldType {
  none,
  text,
  multilineText,
  password,
  id,
  mobile,
  email,
  otp,
  name,
  age,
}

enum TextFieldStyle { filled, outlined, underlined }

enum TextFieldState { enabled, disabled, focused }

class QuiltTextField extends StatefulWidget {
  final String? hint;
  final TextFieldStyle textFieldStyle;
  final TextFieldState textFieldState;
  final TextFieldType textFieldType;
  final ValueChanged<String>? onChanged;
  final Duration? debounceDuration;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isDisposeController;
  final TextAlign textAlign;
  final bool autoValidate;
  final int? maxLength;
  final ValueChanged<bool>? onValidation;
  final EdgeInsets? padding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onSuffixIconTapped;
  final int? maxLines;
  final TapRegionCallback? onTouchOutside;
  final ValueChanged<String>? onSubmitted;
  final bool? readOnly;

  final InputDecoration? filledEnabledStyle;
  final InputDecoration? filledDisabledStyle;
  final InputDecoration? filledFocusedStyle;
  final InputDecoration? outlinedEnabledStyle;
  final InputDecoration? outlinedDisabledStyle;
  final InputDecoration? outlinedFocusedStyle;
  final InputDecoration? underlinedEnabledStyle;
  final InputDecoration? underlinedDisabledStyle;
  final InputDecoration? underlinedFocusedStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  final Color? cursorColor;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final TapRegionCallback? onTapOutside;

  final bool showMaxLengthIndicator;

  const QuiltTextField({
    super.key,
    this.hint,
    required this.textFieldStyle,
    required this.textFieldState,
    required this.textFieldType,
    this.onChanged,
    this.debounceDuration,
    this.controller,
    this.onTap,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
    this.isDisposeController = true,
    this.autoValidate = false,
    this.textAlign = TextAlign.start,
    this.onValidation,
    this.padding,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIconTapped,
    this.onTouchOutside,
    this.onSubmitted,
    this.filledEnabledStyle,
    this.filledDisabledStyle,
    this.filledFocusedStyle,
    this.outlinedEnabledStyle,
    this.outlinedDisabledStyle,
    this.outlinedFocusedStyle,
    this.underlinedEnabledStyle,
    this.underlinedDisabledStyle,
    this.underlinedFocusedStyle,
    this.hintStyle,
    this.textStyle,
    this.maxLength,
    this.cursorColor,
    this.minLines,
    this.inputFormatters,
    this.onTapOutside,
    this.readOnly,
    this.showMaxLengthIndicator = true,
  });

  @override
  QuiltTextFieldState createState() => QuiltTextFieldState();
}

class QuiltTextFieldState extends State<QuiltTextField> {
  Timer? _debounce;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.textFieldType != TextFieldType.password) {
      _obscureText = false;
    }
    // if (widget.isDisposeController) {
    //   _focusNode.addListener(() => setState(() {}));
    // }
  }

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }

  InputDecoration _getInputDecoration() {
    final baseDecoration = _getBaseInputDecoration();
    return baseDecoration.copyWith(
      hintText: widget.hint,
      hintStyle: widget.hintStyle,
      contentPadding: widget.padding,
      suffixIcon: _buildSuffixIcon(),
      prefixIcon: _buildPrefixIcon(),
      prefixIconConstraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
    );
  }

  InputDecoration _getBaseInputDecoration() {
    switch (widget.textFieldStyle) {
      case TextFieldStyle.filled:
        return widget.textFieldState == TextFieldState.enabled
            ? (widget.filledEnabledStyle ?? QuiltTheme.filledEnabled)
            : widget.textFieldState == TextFieldState.disabled
            ? (widget.filledDisabledStyle ?? QuiltTheme.filledDisabled)
            : (widget.filledFocusedStyle ?? QuiltTheme.filledFocused);

      case TextFieldStyle.outlined:
        return widget.textFieldState == TextFieldState.enabled
            ? (widget.outlinedEnabledStyle ?? QuiltTheme.outlinedEnabled)
            : widget.textFieldState == TextFieldState.disabled
            ? (widget.outlinedDisabledStyle ?? QuiltTheme.outlinedDisabled)
            : (widget.outlinedFocusedStyle ?? QuiltTheme.outlinedFocused);

      case TextFieldStyle.underlined:
        return widget.textFieldState == TextFieldState.enabled
            ? (widget.underlinedEnabledStyle ?? QuiltTheme.underlinedEnabled)
            : widget.textFieldState == TextFieldState.disabled
            ? (widget.underlinedDisabledStyle ?? QuiltTheme.underlinedDisabled)
            : (widget.underlinedFocusedStyle ?? QuiltTheme.underlinedFocused);
    }
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 0),
          child: widget.prefixIcon,
        ),
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.textFieldType == TextFieldType.password) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onSuffixIconTapped,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.suffixIcon,
        ),
      );
    }
    return null;
  }

  TextStyle _getTextStyle() {
    return widget.textStyle ?? QuiltTheme.simpleWhiteTextStyle;
  }

  bool _validateInput(String value) {
    switch (widget.textFieldType) {
      case TextFieldType.text:
        return value.isNotEmpty;
      case TextFieldType.multilineText:
        return value.isNotEmpty;
      case TextFieldType.password:
        return value.length >= 6;
      case TextFieldType.id:
        return value.isNotEmpty;
      case TextFieldType.mobile:
        return RegExp(r'^\d{10}$').hasMatch(value);
      case TextFieldType.email:
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
      case TextFieldType.otp:
        return RegExp(r'^\d{6}$').hasMatch(value);
      case TextFieldType.name:
        if (value.isEmpty) {
          return true;
        } else {
          return value.isNotEmpty && RegExp(r'^[a-zA-Z ]+$').hasMatch(value);
        }

      case TextFieldType.age:
        return value.isNotEmpty && RegExp(r'^\d+$').hasMatch(value);
      case TextFieldType.none:
        return true;
    }
  }

  void _onTextChanged(String value) {
    if (widget.textFieldType == TextFieldType.age &&
        value.isNotEmpty &&
        value.startsWith('0')) {
      final newValue = value.replaceFirst(RegExp(r'^0+'), '');
      _controller.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );
      value = newValue;
    }
    if (widget.debounceDuration != null) {
      _debounce?.cancel();
      _debounce = Timer(widget.debounceDuration!, () {
        widget.onChanged?.call(value);
        widget.onValidation?.call(_validateInput(value.trim()));
      });
    } else {
      widget.onChanged?.call(value);
      widget.onValidation?.call(_validateInput(value.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      minLines: widget.minLines ?? 1,
      maxLength: widget.maxLength,
      buildCounter: widget.showMaxLengthIndicator
          ? null
          : (
              _, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) => null,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      autofocus: widget.autofocus,
      keyboardType: _getKeyboardType(),
      obscureText: _obscureText,
      enabled: widget.textFieldState != TextFieldState.disabled,
      style: _getTextStyle(),
      onChanged: _onTextChanged,
      decoration: _getInputDecoration(),
      textAlignVertical: TextAlignVertical.center,
      onTapOutside: widget.onTapOutside,
      onSubmitted: widget.onSubmitted,
      cursorColor: widget.cursorColor,
      inputFormatters: widget.inputFormatters,
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.textFieldType) {
      case TextFieldType.text:
        return TextInputType.text;
      case TextFieldType.multilineText:
        return TextInputType.multiline;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.id:
        return TextInputType.text;
      case TextFieldType.mobile:
        return TextInputType.phone;
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.otp:
        return TextInputType.number;
      case TextFieldType.name:
        return TextInputType.text;
      case TextFieldType.age:
        return TextInputType.number;
      case TextFieldType.none:
        return TextInputType.none;
    }
  }
}
