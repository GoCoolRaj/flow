enum Flavor { staging, demo, prod }

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.staging:
        return 'Quilt Flow Staging';
      case Flavor.demo:
        return 'Quilt Flow Demo';
      case Flavor.prod:
        return 'Quilt Flow Prod';
      default:
        return 'title';
    }
  }
}
