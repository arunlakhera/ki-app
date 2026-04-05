import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── Profile Images ───────────────────────────────────────────────────────

  Future<String> uploadProfileImage(File file) async {
    final ext = file.path.split('.').last;
    final ref = _storage.ref('users/$_uid/profile.$ext');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<void> deleteProfileImage() async {
    try {
      final ref = _storage.ref('users/$_uid/');
      final result = await ref.listAll();
      for (final item in result.items) {
        if (item.name.startsWith('profile')) {
          await item.delete();
        }
      }
    } catch (_) {
      // Ignore if no profile image exists
    }
  }

  // ── Post Images ──────────────────────────────────────────────────────────

  Future<String> uploadPostImage({
    required File file,
    required String postId,
  }) async {
    final ext = file.path.split('.').last;
    final ref = _storage.ref('posts/$postId/image.$ext');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<void> deletePostImage(String postId) async {
    try {
      final ref = _storage.ref('posts/$postId/');
      final result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
    } catch (_) {
      // Ignore if no image exists
    }
  }

  // ── Upload with progress ─────────────────────────────────────────────────

  UploadTask uploadWithProgress({
    required File file,
    required String path,
  }) {
    final ext = file.path.split('.').last;
    final ref = _storage.ref(path);
    return ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    );
  }

  // ── Get download URL ─────────────────────────────────────────────────────

  Future<String> getDownloadUrl(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}
