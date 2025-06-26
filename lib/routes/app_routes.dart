import 'package:flutter/material.dart';
import '../presentation/user_type_selection/user_type_selection.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/supplier_dashboard/supplier_dashboard.dart';
import '../presentation/factory_registration/factory_registration.dart';
import '../presentation/supplier_registration/supplier_registration.dart';
import '../presentation/material_listing_creation/material_listing_creation.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String userTypeSelection = '/user-type-selection';
  static const String loginScreen = '/login-screen';
  static const String supplierDashboard = '/supplier-dashboard';
  static const String factoryRegistration = '/factory-registration';
  static const String supplierRegistration = '/supplier-registration';
  static const String materialListingCreation = '/material-listing-creation';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const UserTypeSelection(),
    userTypeSelection: (context) => const UserTypeSelection(),
    loginScreen: (context) => const LoginScreen(),
    supplierDashboard: (context) => const SupplierDashboard(),
    factoryRegistration: (context) => const FactoryRegistration(),
    supplierRegistration: (context) => const SupplierRegistration(),
    materialListingCreation: (context) => const MaterialListingCreation(),
    // TODO: Add your other routes here
  };
}
