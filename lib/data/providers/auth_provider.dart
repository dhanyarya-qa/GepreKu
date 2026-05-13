import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

// Firebase Auth Instance
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

// Auth State Stream
final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Current User Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }
      
      return FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots()
          .map((doc) {
        if (!doc.exists) return null;
        return User.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Auth Service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref ref;
  
  AuthService(this.ref);
  
  firebase_auth.FirebaseAuth get _auth => ref.read(firebaseAuthProvider);
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  // Sign In with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) return null;
      
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      
      if (!userDoc.exists) return null;
      
      return User.fromJson({
        'id': userDoc.id,
        ...userDoc.data()!,
      });
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign Up with Email & Password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
    UserRole role = UserRole.customer,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) return null;
      
      final user = User(
        id: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        outletId: null,
        createdAt: DateTime.now(),
      );
      
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson());
      
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Get Current User ID
  String? get currentUserId => _auth.currentUser?.uid;
}
