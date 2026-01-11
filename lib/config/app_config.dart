class AppConfig {
  static const String appName = 'ZIGCLIP';
  static const String appVersion = '1.0.0';
  static const int rankingTopCount = 100;
  static const bool enableDebugLogs = false;
  
  static void log(String message) {
    if (enableDebugLogs) {
      print('[ZIGCLIP] $message');
    }
  }
}
