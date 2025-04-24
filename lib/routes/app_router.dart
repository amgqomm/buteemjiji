import 'package:auto_route/auto_route.dart';
import '../models/task_model.dart';
import '../screens/home_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/complete_sign_up_screen.dart';
import '../screens/tasks/add_task_screen.dart';
import '../screens/tasks/edit_task_screen.dart';
import '../utils/app_enums.dart';
import 'package:flutter/cupertino.dart';

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
    AutoRoute(page: AddTaskRoute.page),
    AutoRoute(page: EditTaskRoute.page),
  ];
}