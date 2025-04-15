// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CompleteSignUpScreen]
class CompleteSignUpRoute extends PageRouteInfo<CompleteSignUpRouteArgs> {
  CompleteSignUpRoute({
    Key? key,
    required String uid,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
         CompleteSignUpRoute.name,
         args: CompleteSignUpRouteArgs(key: key, uid: uid, email: email),
         rawPathParams: {'uid': uid, 'email': email},
         initialChildren: children,
       );

  static const String name = 'CompleteSignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CompleteSignUpRouteArgs>(
        orElse:
            () => CompleteSignUpRouteArgs(
              uid: pathParams.getString('uid'),
              email: pathParams.getString('email'),
            ),
      );
      return CompleteSignUpScreen(
        key: args.key,
        uid: args.uid,
        email: args.email,
      );
    },
  );
}

class CompleteSignUpRouteArgs {
  const CompleteSignUpRouteArgs({
    this.key,
    required this.uid,
    required this.email,
  });

  final Key? key;

  final String uid;

  final String email;

  @override
  String toString() {
    return 'CompleteSignUpRouteArgs{key: $key, uid: $uid, email: $email}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}
