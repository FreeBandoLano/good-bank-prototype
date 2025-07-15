import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String uid;
  final String nationalId;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String? photoUrl;
  final int tokenBalance;
  final int trustScore;
  final bool isVerified;
  final DateTime createdAt;

  UserData({
    required this.uid,
    required this.nationalId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    this.photoUrl,
    required this.tokenBalance,
    required this.trustScore,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      uid: doc.id,
      nationalId: data['nationalId'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      photoUrl: data['photoUrl'],
      tokenBalance: data['tokenBalance'] ?? 0,
      trustScore: data['trustScore'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  String get fullName => '$firstName $lastName';
}

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load current user data
  Future<void> loadCurrentUser() async {
    try {
      _setLoading(true);
      _clearError();

      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _currentUser = UserData.fromFirestore(doc);
        }
      }
    } catch (e) {
      _setError('Failed to load user data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user token balance
  Future<void> updateTokenBalance(int newBalance) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'tokenBalance': newBalance,
        });
        
        // Update local data
        if (_currentUser != null) {
          _currentUser = UserData(
            uid: _currentUser!.uid,
            nationalId: _currentUser!.nationalId,
            firstName: _currentUser!.firstName,
            lastName: _currentUser!.lastName,
            email: _currentUser!.email,
            dateOfBirth: _currentUser!.dateOfBirth,
            photoUrl: _currentUser!.photoUrl,
            tokenBalance: newBalance,
            trustScore: _currentUser!.trustScore,
            isVerified: _currentUser!.isVerified,
            createdAt: _currentUser!.createdAt,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to update token balance: ${e.toString()}');
    }
  }

  // Add tokens (for completed tasks)
  Future<void> addTokens(int tokens) async {
    if (_currentUser != null) {
      await updateTokenBalance(_currentUser!.tokenBalance + tokens);
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