extension LaYouExtensionString on String {
  String get capitalizeFirst =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
