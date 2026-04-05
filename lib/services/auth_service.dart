import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Email & Password Sign Up ─────────────────────────────────────────────

  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update display name
    await cred.user?.updateDisplayName(name);

    // Create user document in Firestore
    final now = DateTime.now();
    final user = UserModel(
      uid: cred.user!.uid,
      name: name,
      email: email,
      phone: phone,
      userType: userType,
      createdAt: now,
      updatedAt: now,
    );
    await _db.collection('users').doc(cred.user!.uid).set(user.toFirestore());

    return cred;
  }

  // ── Email & Password Sign In ─────────────────────────────────────────────

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ── Phone OTP ────────────────────────────────────────────────────────────

  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onAutoVerified,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException) onFailed,
    required void Function(String) onAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: onAutoVerified,
      verificationFailed: onFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Link phone credential to existing email account
  Future<UserCredential> linkPhoneCredential({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _auth.currentUser!.linkWithCredential(credential);
  }

  // ── Get User Profile ─────────────────────────────────────────────────────

  Future<UserModel?> getUserProfile([String? uid]) async {
    final id = uid ?? currentUser?.uid;
    if (id == null) return null;
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> userProfileStream([String? uid]) {
    final id = uid ?? currentUser?.uid;
    if (id == null) return Stream.value(null);
    return _db.collection('users').doc(id).snapshots().map(
      (doc) => doc.exists ? UserModel.fromFirestore(doc) : null,
    );
  }

  // ── Update User Profile ──────────────────────────────────────────────────

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    data['updatedAt'] = Timestamp.now();
    await _db.collection('users').doc(currentUser!.uid).update(data);
  }

  // ── Password Reset ───────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Sign Out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Delete Account ───────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    if (currentUser == null) return;
    await _db.collection('users').doc(currentUser!.uid).delete();
    await currentUser!.delete();
  }
}
