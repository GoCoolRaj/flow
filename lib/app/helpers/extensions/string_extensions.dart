extension StringUtil on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isEmail {
    final value = this?.trim();
    if (value == null || value.isEmpty) return false;
    // RFC5322-inspired check: local part + @ + domain with at least one dot.
    const pattern =
        r"^[A-Za-z0-9.!#%&\'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$";
    return RegExp(pattern).hasMatch(value);
  }

  String get removeSpaces => this?.replaceAll(' ', '').toUpperCase() ?? '';

  DateTime get convertStringToDateTime => DateTime.parse(this ?? '');

  String get toCapitalized {
    return isNullOrEmpty
        ? ''
        : '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}';
  }

  bool notContains(String value) => !(this?.contains(value) ?? false);

  String get normalizedEmail => this?.trim().toLowerCase() ?? '';
}
