import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.bio,
    this.university,
    this.level,
    this.subjects = const [],
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final String? university;
  final String? level;
  final List<String> subjects;

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      university: data['university'] as String?,
      level: data['level'] as String?,
      subjects: List<String>.from(data['subjects'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'bio': bio,
    'university': university,
    'level': level,
    'subjects': subjects,
    'updatedAt': FieldValue.serverTimestamp(),
    if (isNew) 'createdAt': FieldValue.serverTimestamp(),
  };

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    String? university,
    String? level,
    List<String>? subjects,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      university: university ?? this.university,
      level: level ?? this.level,
      subjects: subjects ?? this.subjects,
    );
  }
}
