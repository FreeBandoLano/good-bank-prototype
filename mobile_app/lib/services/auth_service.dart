import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthService() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  // Sign in with National ID data (placeholder for ReadID integration)
  Future<bool> signInWithNationalId({
    required String nationalId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    String? photoUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // For Phase 1: Create account using email/password based on national ID
      // In Phase 2: This will be replaced with proper ReadID verification
      String email = '${nationalId.toLowerCase()}@goodbank.bw';
      String password = _generatePasswordFromId(nationalId);

      UserCredential credential;
      
      try {
        // Try to sign in first
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // If sign in fails, create new account
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // Create user profile in Firestore
        await _createUserProfile(
          uid: credential.user!.uid,
          nationalId: nationalId,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          email: email,
          photoUrl: photoUrl,
        );
      }

      return true;
    } catch (e) {
      _setError('Authentication failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile({
    required String uid,
    required String nationalId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String email,
    String? photoUrl,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'nationalId': nationalId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'tokenBalance': 0,
      'trustScore': 0,
      'isVerified': true, // Since they used national ID
    });
  }

  // Generate a deterministic password from national ID
  String _generatePasswordFromId(String nationalId) {
    // Simple hash - in production, use proper hashing
    return 'GB${nationalId.hashCode.abs()}';
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    }
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 