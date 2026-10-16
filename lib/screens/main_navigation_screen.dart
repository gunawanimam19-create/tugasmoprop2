import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../theme/app_theme.dart';
import '../models/order_model.dart';
import 'home_screen.dart';
import 'menu_catalog_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);
    final activeOrdersCount = state.orders.where((o) => o.status != OrderStatus.completed).length;

    final screens = [
      HomeScreen(onTabChange: _onTabSelect),
      const MenuCatalogScreen(),
      CartScreen(onTabChange: _onTabSelect),
      OrderHistoryScreen(onTabChange: _onTabSelect),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelect,
        indicatorColor: AppTheme.primaryOrange.withOpacity(0.2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primaryOrange),
            label: 'Beranda',
          ),
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu_rounded, color: AppTheme.primaryOrange),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: state.cartCount > 0
                ? Badge.count(
                    count: state.cartCount,
                    backgroundColor: AppTheme.primaryOrange,
                    child: const Icon(Icons.shopping_cart_outlined),
                  )
                : const Icon(Icons.shopping_cart_outlined),
            selectedIcon: state.cartCount > 0
                ? Badge.count(
                    count: state.cartCount,
                    backgroundColor: AppTheme.primaryOrange,
                    child: const Icon(Icons.shopping_cart_rounded, color: AppTheme.primaryOrange),
                  )
                : const Icon(Icons.shopping_cart_rounded, color: AppTheme.primaryOrange),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: activeOrdersCount > 0
                ? Badge.count(
                    count: activeOrdersCount,
                    backgroundColor: AppTheme.secondaryGreen,
                    child: const Icon(Icons.receipt_long_outlined),
                  )
                : const Icon(Icons.receipt_long_outlined),
            selectedIcon: activeOrdersCount > 0
                ? Badge.count(
                    count: activeOrdersCount,
                    backgroundColor: AppTheme.secondaryGreen,
                    child: const Icon(Icons.receipt_long_rounded, color: AppTheme.primaryOrange),
                  )
                : const Icon(Icons.receipt_long_rounded, color: AppTheme.primaryOrange),
            label: 'Pesanan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryOrange),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
