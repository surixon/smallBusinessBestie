import 'package:get_it/get_it.dart';
import 'package:smalll_business_bestie/provider/account_reinstate_provider.dart';
import 'package:smalll_business_bestie/provider/add_expenses_provider.dart';
import 'package:smalll_business_bestie/provider/add_income_provider.dart';
import 'package:smalll_business_bestie/provider/add_material_provider.dart';
import 'package:smalll_business_bestie/provider/add_product_provider.dart';
import 'package:smalll_business_bestie/provider/create_account_provider.dart';
import 'package:smalll_business_bestie/provider/dashboard_provider.dart';
import 'package:smalll_business_bestie/provider/expenses_provider.dart';
import 'package:smalll_business_bestie/provider/forgot_password_provider.dart';
import 'package:smalll_business_bestie/provider/home_provider.dart';
import 'package:smalll_business_bestie/provider/income_provider.dart';
import 'package:smalll_business_bestie/provider/login_provider.dart';
import 'package:smalll_business_bestie/provider/material_view_provider.dart';
import 'package:smalll_business_bestie/provider/products_view_provider.dart';
import 'package:smalll_business_bestie/provider/settings_provider.dart';
import 'package:smalll_business_bestie/provider/subscription_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => LoginProvider());
  locator.registerFactory(() => ForgotPasswordProvider());
  locator.registerFactory(() => CreateAccountProvider());
  locator.registerFactory(() => DashboardProvider());
  locator.registerFactory(() => AddMaterialProvider());
  locator.registerFactory(() => AddIncomeProvider());
  locator.registerFactory(() => AddProductProvider());
  locator.registerFactory(() => AddExpenseProvider());
  locator.registerFactory(() => HomeProvider());
  locator.registerFactory(() => IncomeProvider());
  locator.registerFactory(() => ExpensesProvider());
  locator.registerFactory(() => MaterialViewProvider());
  locator.registerFactory(() => ProductsViewProvider());
  locator.registerFactory(() => SettingsProvider());
  locator.registerFactory(() => AccountReInStateProvider());
  locator.registerFactory(() => SubscriptionProvider());
}
