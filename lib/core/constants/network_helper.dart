import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:paypact/core/routes/app_router.dart';

class NetworkHelper {
  static bool currentStatus = true;

  static Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;
    return await InternetConnectionChecker.instance.hasConnection;
  }

  static Stream<bool> get internetStatusStream =>
      Connectivity().onConnectivityChanged.asyncMap(
        (result) async =>
            result != ConnectivityResult.none &&
            await InternetConnectionChecker.instance.hasConnection,
      );

  static void initialize() {
    internetStatusStream.listen((status) {
      currentStatus = status;
      AppRouter.router.refresh();
    });
  }
}
