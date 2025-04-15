import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../screens/home_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/complete_sign_up_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page, initial: true),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: CompleteSignUpRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];
}

// @MaterialAutoRouter(
//   replaceInRouteName: 'Screen,Route',
//   routes: <AutoRoute>[
//     AutoRoute(page: SignInScreen, initial: true),
//     AutoRoute(page: SignUpScreen),
//     AutoRoute(page: CompleteSignUpScreen),
//     AutoRoute(page: HomeScreen),
//   ],
// )
// class $AppRouter {}