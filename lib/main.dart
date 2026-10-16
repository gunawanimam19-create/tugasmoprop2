import 'package:flutter/material.dart';
import 'state/canteen_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KantinBuSariApp());
}

class KantinBuSariApp extends StatefulWidget {
  const KantinBuSariApp({super.key});

  @override
  State<KantinBuSariApp> createState() => _KantinBuSariAppState();
}

class _KantinBuSariAppState extends State<KantinBuSariApp> {
  late final CanteenState _canteenState;

  @override
  void initState() {
    super.initState();
    _canteenState = CanteenState();
  }

  @override
  void dispose() {
    _canteenState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CanteenScope(
      state: _canteenState,
      child: ListenableBuilder(
        listenable: _canteenState,
        builder: (context, _) {
          return MaterialApp(
            title: 'Kantin Bu Sari',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _canteenState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}
