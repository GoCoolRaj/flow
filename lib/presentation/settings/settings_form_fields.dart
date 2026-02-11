import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';

class SettingsGradientTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final VoidCallback? onTapOutside;

  const SettingsGradientTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.enabled = true,
    this.onTapOutside,
  });

  @override
  State<SettingsGradientTextField> createState() =>
      _SettingsGradientTextFieldState();
}

class _SettingsGradientTextFieldState extends State<SettingsGradientTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AuthTheme.profileFieldOuterDecoration(isFocused: _isFocused),
      padding: const EdgeInsets.all(1.4),
      child: Container(
        decoration: AuthTheme.profileFieldInnerDecoration(),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: AuthTheme.profileInputDecoration(widget.hintText),
          style: AuthTheme.profileInputText,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onTapOutside: (_) => widget.onTapOutside?.call(),
        ),
      ),
    );
  }
}

class SettingsGradientBox extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const SettingsGradientBox({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration: AuthTheme.profileFieldOuterDecoration(),
        padding: const EdgeInsets.all(1.4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: AuthTheme.profileFieldInnerDecoration(),
          child: child,
        ),
      ),
    );
  }
}

class SettingsGenderOption {
  final String label;
  final String value;
  final String iconAsset;

  const SettingsGenderOption({
    required this.label,
    required this.value,
    required this.iconAsset,
  });
}

class SettingsGenderGrid extends StatelessWidget {
  final String selectedGender;
  final List<SettingsGenderOption> options;
  final ValueChanged<String> onGenderSelected;

  const SettingsGenderGrid({
    super.key,
    required this.selectedGender,
    required this.options,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: options.map((option) {
        final bool isSelected = selectedGender == option.value;
        return GestureDetector(
          onTap: () => onGenderSelected(option.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? QuiltTheme.quiltGradient : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFF3D3D3D),
              ),
            ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      option.iconAsset,
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(option.label, style: AuthTheme.profileChipText),
                  ],
                ),
          ),
        );
      }).toList(),
    );
  }
}
