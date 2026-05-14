import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialize Firebase when ready
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // TODO: Initialize Hive for local storage
  // await Hive.initFlutter();
  // await Hive.openBox('app_cache');
  // await Hive.openBox('products_cache');
  // await Hive.openBox('cart_cache');
  
  runApp(
    const ProviderScope(
      child: GepreKuApp(),
    ),
  );
}

class GepreKuApp extends ConsumerWidget {
  const GepreKuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp(
      title: 'GepreKu - Ultimate 3D Restaurant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
