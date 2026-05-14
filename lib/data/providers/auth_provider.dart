import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

// Mock Auth State Provider
final authStateProvider = StreamProvider<MockUser?>((ref) {
  // Return mock user for demo
  return Stream.value(MockUser(uid: 'demo_user'));
});

// Mock Current User Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  // Return mock user data
  return Stream.value(User(
    id: 'demo_user',
    name: 'Demo User',
    email: 'demo@gepreku.com',
    phone: '+6281234567890',
    role: UserRole.customer,
    outletId: null,
    createdAt: DateTime.now(),
  ));
});

// Mock Auth Service
final authServiceProvider = Provider<MockAuthService>((ref) {
  return MockAuthService();
});

class MockUser {
  final String uid;
  MockUser({required this.uid});
}

class MockAuthService {
  String? get currentUserId => 'demo_user';
  
  Future<User?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 'demo_user',
      name: 'Demo User',
      email: email,
      role: UserRole.customer,
      createdAt: DateTime.now(),
    );
  }
  
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
