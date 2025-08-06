import 'dart:io';

class NetworkHelper {
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Stream<bool> get internetStatusStream async* {
    yield await hasInternet();
    await for (final _ in Stream.periodic(const Duration(seconds: 3))) {
      yield await hasInternet();
    }
  }
}
