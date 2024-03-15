class AppData {
  static final AppData _appData = AppData._internal();

  bool entitlementIsActive = false;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
