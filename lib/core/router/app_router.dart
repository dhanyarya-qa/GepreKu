import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/customer/screens/splash_screen.dart';
import '../../presentation/customer/screens/home_screen.dart';
import '../../presentation/customer/screens/qr_scanner_screen.dart';
import '../../presentation/customer/screens/menu_screen.dart';
import '../../presentation/customer/screens/cart_screen.dart';
import '../../presentation/customer/screens/checkout_screen.dart';
import '../../presentation/customer/screens/order_history_screen.dart';
import '../../presentation/customer/screens/store_locator_screen.dart';
import '../../presentation/kds/screens/kds_home_screen.dart';
import '../../presentation/owner/screens/owner_dashboard_screen.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/qr-scanner':
        return MaterialPageRoute(builder: (_) => const QRScannerScreen());
      case '/menu':
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case '/order-history':
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case '/store-locator':
        return MaterialPageRoute(builder: (_) => const StoreLocatorScreen());
      case '/kds':
        return MaterialPageRoute(builder: (_) => const KDSHomeScreen());
      case '/owner':
        return MaterialPageRoute(builder: (_) => const OwnerDashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
