import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorUid;
  final String authorName;
  final String authorInitials;
  final String? authorProfileImageUrl;
  final String content;
  final String? imageUrl;
  final String? location;
  final List<String> skills;
  final bool isAvailableForWork;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorUid,
    required this.authorName,
    required this.authorInitials,
    this.authorProfileImageUrl,
    required this.content,
    this.imageUrl,
    this.location,
    this.skills = const [],
    this.isAvailableForWork = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      authorUid: data['authorUid'] ?? '',
      authorName: data['authorName'] ?? '',
      authorInitials: data['authorInitials'] ?? '',
      authorProfileImageUrl: data['authorProfileImageUrl'],
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      location: data['location'],
      skills: List<String>.from(data['skills'] ?? []),
      isAvailableForWork: data['isAvailableForWork'] ?? false,
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorUid': authorUid,
      'authorName': authorName,
      'authorInitials': authorInitials,
      'authorProfileImageUrl': authorProfileImageUrl,
      'content': content,
      'imageUrl': imageUrl,
      'location': location,
      'skills': skills,
      'isAvailableForWork': isAvailableForWork,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
