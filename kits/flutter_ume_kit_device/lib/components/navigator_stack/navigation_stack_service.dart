import 'package:flutter/cupertino.dart';

class NavigatorObserverService extends NavigatorObserver {
  List<Route<dynamic>> routeStack = [];

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack.removeLast();
    if (newRoute != null) {
      routeStack.add(newRoute);
    }
  }

  // Метод для отримання даних роута (якщо це необхідно для відображення)
  List<String> getRouteNames() {
    return routeStack
        .map((route) => route.settings.name ?? 'Unnamed Route')
        .toList();
  }
}
