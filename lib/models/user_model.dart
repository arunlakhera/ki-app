import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'worker' or 'employer'
  final String? profileImageUrl;
  final String? bio;
  final List<String> skills;
  final String? location;
  final bool isAvailableForWork;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.profileImageUrl,
    this.bio,
    this.skills = const [],
    this.location,
    this.isAvailableForWork = false,
    required this.createdAt,
    required this.updatedAt,
    this.fcmToken,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      userType: data['userType'] ?? 'worker',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'],
      skills: List<String>.from(data['skills'] ?? []),
      location: data['location'],
      isAvailableForWork: data['isAvailableForWork'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmToken: data['fcmToken'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'skills': skills,
      'location': location,
      'isAvailableForWork': isAvailableForWork,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'fcmToken': fcmToken,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? profileImageUrl,
    String? bio,
    List<String>? skills,
    String? location,
    bool? isAvailableForWork,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      isAvailableForWork: isAvailableForWork ?? this.isAvailableForWork,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
