import 'package:musicapp/features/Authentication/auth/forgot_password.dart';
import 'package:musicapp/features/Authentication/auth/login.dart';
import 'package:musicapp/features/Authentication/auth/registerView.dart';
import 'package:musicapp/features/home/homeview.dart';
import 'package:musicapp/features/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/loginScreen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/ForgotPasswordScreen',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/HomeScreen',
      builder: (context, state) => const HomeView(),
    ),
  ]);
}
