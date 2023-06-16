enum AppRoutes {
  home,
  login,
  userWalkthrough,
  addGoals,
  signUp,
  forgotPassword,
  settings,
  accounts,
  notification,
  onboarding,
  myGoals,
  homeView,
  // add more routes as needed
}

extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.home:
        return '/home';
      case AppRoutes.login:
        return '/login';
      case AppRoutes.userWalkthrough:
        return '/user_walkthrough';
      case AppRoutes.addGoals:
        return '/add_goals';
      case AppRoutes.signUp:
        return '/sign_up';
      case AppRoutes.forgotPassword:
        return '/forgot_password';
      case AppRoutes.settings:
        return '/settings';
      case AppRoutes.accounts:
        return '/accounts';
      case AppRoutes.notification:
        return '/notification';
      case AppRoutes.onboarding:
        return '/onboarding';
      case AppRoutes.myGoals:
        return '/my_goals';
      case AppRoutes.homeView:
        return '/home_view';
      // add more routes as needed
    }
  }
}
