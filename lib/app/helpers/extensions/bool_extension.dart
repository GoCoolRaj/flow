extension BoolExtension on bool {
  bool get not => !this;
}

extension BoolValueExtension on bool? {
  bool get absolute => this ?? false;
}
