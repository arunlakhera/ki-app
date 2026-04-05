import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection('users');

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> createUser(UserModel user) async {
    await _usersRef.doc(user.uid).set(user.toFirestore());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await _usersRef.doc(uid).update(data);
  }

  Stream<UserModel?> userStream(String uid) {
    return _usersRef.doc(uid).snapshots().map(
      (doc) => doc.exists ? UserModel.fromFirestore(doc) : null,
    );
  }

  // ── Posts ────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _db.collection('posts');

  Future<String> createPost(PostModel post) async {
    final docRef = await _postsRef.add(post.toFirestore());
    return docRef.id;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _postsRef.doc(postId).update(data);
  }

  Future<void> deletePost(String postId) async {
    await _postsRef.doc(postId).delete();
  }

  // Get all posts ordered by creation date (newest first)
  Stream<List<PostModel>> postsStream() {
    return _postsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PostModel.fromFirestore(d)).toList());
  }

  // Get posts by a specific user
  Stream<List<PostModel>> userPostsStream(String uid) {
    return _postsRef
        .where('authorUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PostModel.fromFirestore(d)).toList());
  }

  // Get paginated posts
  Future<List<PostModel>> getPosts({int limit = 20, DocumentSnapshot? startAfter}) async {
    Query<Map<String, dynamic>> query = _postsRef
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snap = await query.get();
    return snap.docs.map((d) => PostModel.fromFirestore(d)).toList();
  }

  // Like / unlike a post
  Future<void> toggleLike(String postId, String uid) async {
    final likeRef = _postsRef.doc(postId).collection('likes').doc(uid);
    final likeDoc = await likeRef.get();
    if (likeDoc.exists) {
      await likeRef.delete();
      await _postsRef.doc(postId).update({'likesCount': FieldValue.increment(-1)});
    } else {
      await likeRef.set({'likedAt': Timestamp.now()});
      await _postsRef.doc(postId).update({'likesCount': FieldValue.increment(1)});
    }
  }

  Future<bool> isPostLiked(String postId, String uid) async {
    final doc = await _postsRef.doc(postId).collection('likes').doc(uid).get();
    return doc.exists;
  }

  // ── Jobs ─────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _jobsRef =>
      _db.collection('jobs');

  Future<String> createJob(JobModel job) async {
    final docRef = await _jobsRef.add(job.toFirestore());
    return docRef.id;
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    await _jobsRef.doc(jobId).update(data);
  }

  Future<void> deleteJob(String jobId) async {
    await _jobsRef.doc(jobId).delete();
  }

  // Get all active jobs (newest first)
  Stream<List<JobModel>> jobsStream() {
    return _jobsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => JobModel.fromFirestore(d)).toList());
  }

  // Get jobs by employer
  Stream<List<JobModel>> employerJobsStream(String uid) {
    return _jobsRef
        .where('employerUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => JobModel.fromFirestore(d)).toList());
  }

  // Search jobs by category
  Stream<List<JobModel>> jobsByCategoryStream(String category) {
    return _jobsRef
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => JobModel.fromFirestore(d)).toList());
  }

  // Search jobs by location
  Future<List<JobModel>> searchJobs({
    String? category,
    String? location,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _jobsRef.where('isActive', isEqualTo: true);
    if (category != null) query = query.where('category', isEqualTo: category);
    if (location != null) query = query.where('location', isEqualTo: location);
    query = query.orderBy('createdAt', descending: true).limit(limit);
    final snap = await query.get();
    return snap.docs.map((d) => JobModel.fromFirestore(d)).toList();
  }

  // ── Job Applications ─────────────────────────────────────────────────────

  Future<void> applyForJob(String jobId, String uid) async {
    final appRef = _jobsRef.doc(jobId).collection('applicants').doc(uid);
    await appRef.set({
      'appliedAt': Timestamp.now(),
      'status': 'pending', // pending, accepted, rejected
    });
    await _jobsRef.doc(jobId).update({'applicantsCount': FieldValue.increment(1)});
  }

  Future<bool> hasApplied(String jobId, String uid) async {
    final doc = await _jobsRef.doc(jobId).collection('applicants').doc(uid).get();
    return doc.exists;
  }

  Stream<List<Map<String, dynamic>>> jobApplicantsStream(String jobId) {
    return _jobsRef.doc(jobId).collection('applicants')
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
          final data = d.data();
          data['uid'] = d.id;
          return data;
        }).toList());
  }
}
