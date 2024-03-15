import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/view/add_expenses_view.dart';
import 'package:smalll_business_bestie/view/add_income_view.dart';
import 'package:smalll_business_bestie/view/add_inventory_view.dart';
import 'package:smalll_business_bestie/view/add_product_view.dart';
import 'package:smalll_business_bestie/view/create_account_view.dart';
import 'package:smalll_business_bestie/view/dashboard_view.dart';
import 'package:smalll_business_bestie/view/forgot_password_view.dart';
import 'package:smalll_business_bestie/view/login_view.dart';
import 'package:smalll_business_bestie/view/inventory_view.dart';
import 'package:smalll_business_bestie/view/settings_view.dart';
import 'package:smalll_business_bestie/view/splash_view.dart';
import 'package:smalll_business_bestie/view/subscription_view.dart';
import 'globals.dart';
import 'helpers/shared_pref.dart';

final router = GoRouter(
  navigatorKey: Globals.navigatorKey,
  initialLocation: AppPaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppPaths.splash,
      name: AppPaths.splash,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SplashView());
      },
    ),
    GoRoute(
      path: AppPaths.login,
      name: AppPaths.login,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginView());
      },
    ),
    GoRoute(
      path: AppPaths.forgotPassword,
      name: AppPaths.forgotPassword,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ForgotPasswordView());
      },
    ),
    GoRoute(
      path: AppPaths.subscription,
      name: AppPaths.subscription,
      pageBuilder: (context, state) {
        Map<String,dynamic>? data = state.extra as Map<String,dynamic>?;
        return  MaterialPage(child: SubscriptionView(isBackDisabled: data?['disableBack'],));
      },
    ),
    GoRoute(
      path: AppPaths.createAccount,
      name: AppPaths.createAccount,
      pageBuilder: (context, state) {
        return const MaterialPage(child: CreateAccountView());
      },
    ),
    GoRoute(
      path: AppPaths.dashboard,
      name: AppPaths.dashboard,
      pageBuilder: (context, state) {
        return const MaterialPage(child: DashboardView());
      },
    ),
    GoRoute(
      path: AppPaths.addMaterial,
      name: AppPaths.addMaterial,
      pageBuilder: (context, state) {
        return MaterialPage(
            child: AddInventoryView(
          materialModel: state.extra as MaterialModel?,
        ));
      },
    ),
    GoRoute(
      path: AppPaths.addProduct,
      name: AppPaths.addProduct,
      pageBuilder: (context, state) {
        return const MaterialPage(child: AddProductView());
      },
    ),
    GoRoute(
      path: AppPaths.addIncome,
      name: AppPaths.addIncome,
      pageBuilder: (context, state) {
        return const MaterialPage(child: AddIncomeView());
      },
    ),
    GoRoute(
      path: AppPaths.addExpense,
      name: AppPaths.addExpense,
      pageBuilder: (context, state) {
        return const MaterialPage(child: AddExpensesView());
      },
    ),
    GoRoute(
      path: AppPaths.settings,
      name: AppPaths.settings,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SettingsView());
      },
    ),
    GoRoute(
      path: AppPaths.material,
      name: AppPaths.material,
      pageBuilder: (context, state) {
        var data = state.extra as Map<String, dynamic>;
        return MaterialPage(
            child: InventoryView(
          from: data['from'],
        ));
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text(
          state.fullPath ??
              state.error?.toString() ??
              state.name ??
              "unknown error",
          textAlign: TextAlign.center,
        ),
      ),
    );
  },
);

class AppPaths {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';
  static const createAccount = '/createAccount';
  static const dashboard = '/dashboard';
  static const addMaterial = '/addMaterial';
  static const material = '/material';
  static const addProduct = '/addProduct';
  static const addIncome = '/addIncome';
  static const addExpense = '/addExpense';
  static const settings = '/settings';
  static const subscription = '/subscription';
}
