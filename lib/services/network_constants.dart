class NetworkConstants {
  static final String apiKey = "arsenmarkaryanfanclub20241008";
  static final String scheme = "http";
  static final String host = "104.248.140.209:7991";

  static String apiUrl(String? path) {
    return '${NetworkConstants.scheme}://${NetworkConstants.host}$path';
  }
}
