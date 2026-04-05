import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String employerUid;
  final String employerName;
  final String title;
  final String description;
  final String location;
  final String category;
  final List<String> requiredSkills;
  final double? salaryMin;
  final double? salaryMax;
  final String salaryType; // 'hourly', 'daily', 'monthly', 'fixed'
  final String jobType; // 'full-time', 'part-time', 'contract', 'one-time'
  final bool isActive;
  final int applicantsCount;
  final DateTime createdAt;
  final DateTime? expiresAt;

  JobModel({
    required this.id,
    required this.employerUid,
    required this.employerName,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    this.requiredSkills = const [],
    this.salaryMin,
    this.salaryMax,
    this.salaryType = 'daily',
    this.jobType = 'full-time',
    this.isActive = true,
    this.applicantsCount = 0,
    required this.createdAt,
    this.expiresAt,
  });

  String get salaryDisplay {
    if (salaryMin == null && salaryMax == null) return 'Negotiable';
    if (salaryMin != null && salaryMax != null) {
      return '₹${salaryMin!.toInt()} - ₹${salaryMax!.toInt()} / $salaryType';
    }
    if (salaryMin != null) return '₹${salaryMin!.toInt()}+ / $salaryType';
    return 'Up to ₹${salaryMax!.toInt()} / $salaryType';
  }

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      employerUid: data['employerUid'] ?? '',
      employerName: data['employerName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      category: data['category'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      salaryMin: (data['salaryMin'] as num?)?.toDouble(),
      salaryMax: (data['salaryMax'] as num?)?.toDouble(),
      salaryType: data['salaryType'] ?? 'daily',
      jobType: data['jobType'] ?? 'full-time',
      isActive: data['isActive'] ?? true,
      applicantsCount: data['applicantsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'employerUid': employerUid,
      'employerName': employerName,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'requiredSkills': requiredSkills,
      'salaryMin': salaryMin,
      'salaryMax': salaryMax,
      'salaryType': salaryType,
      'jobType': jobType,
      'isActive': isActive,
      'applicantsCount': applicantsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }
}
