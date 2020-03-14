class GuideLogs {
  static bool isLogs = false;

  static void e(String message) {
    if (isLogs) {
      print("guild ---------------------start---------------------------");
      print("guild -| $message");
      print("guild ---------------------end---------------------------");
    }
  }
}
