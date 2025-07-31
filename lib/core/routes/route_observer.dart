import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RouteObserverService extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    final from = _getRouteName(previousRoute);
    final to = _getRouteName(route);
    debugPrint('[RouteObserver] PUSHED: from "$from" to "$to"');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final from = _getRouteName(route);
    final to = _getRouteName(previousRoute);
    debugPrint('[RouteObserver] POPPED: from "$from" to "$to"');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final from = _getRouteName(oldRoute);
    final to = _getRouteName(newRoute);
    debugPrint('[RouteObserver] REPLACED: from "$from" to "$to"');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  String _getRouteName(Route? route) {
    if (route == null) return 'null';

    final name = route.settings.name;
    if (name != null && name.isNotEmpty) return name;

    final location = route.settings.arguments;
    if (location is GoRouterState) {
      return location.name ?? location.uri.toString();
    }

    return route.settings.name ?? route.runtimeType.toString();
  }
}
