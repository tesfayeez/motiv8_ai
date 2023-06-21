import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/navigation/navigation_enums.dart';

class NavigationPath {
  final String path;
  final bool isAuthenticated;
  final Map<String, dynamic> parameters;

  NavigationPath(
      {required this.path,
      this.isAuthenticated = false,
      this.parameters = const {}});

  static NavigationPath initial() => NavigationPath(path: '/');
}

class RouteController extends StateNotifier<NavigationPath> {
  final ProviderContainer container;

  RouteController(this.container) : super(NavigationPath.initial());

  void setPath(NavigationPath path) {
    var authController = container.read(authControllerProvider.notifier);
    var isAuthenticated = authController.getCurrentUser() != null;
    state = NavigationPath(
      path: path.path,
      isAuthenticated: isAuthenticated,
      parameters: path.parameters,
    );
  }
}

final routeControllerProvider =
    StateNotifierProvider<RouteController, NavigationPath>((ref) {
  return RouteController(ref.container);
});
