import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreLocatorScreen extends ConsumerWidget {
  const StoreLocatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Outlet'),
      ),
      body: const Center(
        child: Text('Store Locator Screen - To be implemented'),
      ),
    );
  }
}
