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

  // ── Create User Profile (after phone verification) ─────────────────────

  Future<void> createUserProfile({
    required String name,
    required String phone,
    required String userType,
    String? location,
    List<String>? skills,
  }) async {
    if (currentUser == null) return;
    final now = DateTime.now();
    final user = UserModel(
      uid: currentUser!.uid,
      name: name,
      phone: phone,
      userType: userType,
      location: location,
      skills: skills ?? [],
      createdAt: now,
      updatedAt: now,
    );
    await _db.collection('users').doc(currentUser!.uid).set(user.toFirestore());
    await currentUser!.updateDisplayName(name);
  }

  // ── Check if user profile exists ───────────────────────────────────────

  Future<bool> userProfileExists([String? uid]) async {
    final id = uid ?? currentUser?.uid;
    if (id == null) return false;
    final doc = await _db.collection('users').doc(id).get();
    return doc.exists;
  }

  // ── Get User Profile ───────────────────────────────────────────────────

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

  // ── Update User Profile ────────────────────────────────────────────────

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    data['updatedAt'] = Timestamp.now();
    await _db.collection('users').doc(currentUser!.uid).update(data);
  }

  // ── Sign Out ───────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Delete Account ─────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    if (currentUser == null) return;
    await _db.collection('users').doc(currentUser!.uid).delete();
    await currentUser!.delete();
  }
}
