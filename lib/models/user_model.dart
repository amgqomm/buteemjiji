import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../utils/app_enums.dart';

class AppUser extends Equatable {
  final String uid;
  final String username;
  final String email;
  final Gender gender;
  final int age;
  final int level;
  final int healthPoint;
  final int expPoint;
  final int coin;
  final int maxExp;

  const AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.gender,
    required this.age,
    this.level = 1,
    this.healthPoint = 100,
    this.expPoint = 0,
    this.coin = 0,
    this.maxExp = 100,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser(
        uid: doc.id,
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        gender: _genderFromString(data['gender'] ?? ''),
        age: data['age'] ?? 0,
        level: data['level'] ?? 1,
        healthPoint: data['healthPoint'] ?? 100,
        expPoint: data['expPoint'] ?? 0,
        coin: data['coin'] ?? 0,
        maxExp: data['maxExp'] ?? 100
    );
  }

  static Gender _genderFromString(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.other;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'gender': gender.toString().split('.').last,
      'age': age,
      'level': level,
      'healthPoint': healthPoint,
      'expPoint': expPoint,
      'coin': coin,
      'maxExp': maxExp,
    };
  }

  AppUser copyWith({
    String? uid,
    String? username,
    String? email,
    Gender? gender,
    int? age,
    int? level,
    int? healthPoint,
    int? expPoint,
    int? coin,
    int? maxExp,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      level: level ?? this.level,
      healthPoint: healthPoint ?? this.healthPoint,
      expPoint: expPoint ?? this.expPoint,
      coin: coin ?? this.coin,
      maxExp: maxExp ?? this.maxExp,
    );
  }

  @override
  List<Object?> get props => [uid, username, email, gender, age, level, healthPoint, expPoint, coin, maxExp];
}