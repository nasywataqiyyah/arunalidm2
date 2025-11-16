import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential;
  }

  Future<UserCredential> signUp({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String email,
    required String password,
    required String role,
    String? schoolId,
    String? classId,
    bool sendEmailVerification = false,
  }) async {
    final String normalizedFirstName = firstName.trim();
    final String normalizedLastName = lastName.trim();
    final String normalizedFullName =
        ('$normalizedFirstName $normalizedLastName').trim();
    final String normalizedEmail = email.trim().toLowerCase();

    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: normalizedEmail,
          password: password,
        );

    final User? user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Failed to create user.',
      );
    }

    // Update Firebase Auth profile display name
    await user.updateDisplayName(normalizedFullName);
    if (sendEmailVerification && !(user.emailVerified)) {
      await user.sendEmailVerification();
    }

    // Create or merge user profile document
    final DocumentReference<Map<String, dynamic>> docRef = _firestore
        .collection('users')
        .doc(user.uid);
    final DocumentSnapshot<Map<String, dynamic>> existing = await docRef.get();
    final Map<String, Object?> baseProfile = <String, Object?>{
      'first_name': normalizedFirstName,
      'last_name': normalizedLastName,
      'display_name': normalizedFullName,
      'date_of_birth': dateOfBirth.trim(),
      'email': normalizedEmail,
      'uid': user.uid,
      'role': role,
      'school_id': schoolId,
      'class_id': classId,
      'updated_at': FieldValue.serverTimestamp(),
    };
    if (existing.exists) {
      await docRef.set(baseProfile, SetOptions(merge: true));
    } else {
      await docRef.set(<String, Object?>{
        ...baseProfile,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    // Refresh the in-memory user to reflect any profile updates
    await user.reload();

    // Do not keep the user signed in after registration
    await _auth.signOut();
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
