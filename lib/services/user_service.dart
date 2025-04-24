import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  Stream<AppUser?> streamUser(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception('Error updating user: ${e.toString()}');
    }
  }

  Future<void> updateUserStats({
    required String uid,
    required int expChange,
    required int healthChange,
    required int coinChange,
  }) async {
    try {
      final user = await getUser(uid);
      if (user == null) throw Exception('User not found');

      int newExp = user.expPoint + expChange;
      int newHealth = (user.healthPoint + healthChange);
      int newCoin = (user.coin + coinChange) >= 0 ? user.coin + coinChange : 0;

      if (newExp >= user.maxExp) {
        return levelUp(user, expChange);
      }

      if (newHealth <= 0) {
        return levelDown(user);
      }

      await _updateUserFields(uid, {
        'expPoint': newExp,
        'healthPoint': newHealth,
        'coin': newCoin,
      });
    } catch (e) {
      throw Exception('Error updating user stats: ${e.toString()}');
    }
  }

  Future<void> _updateUserFields(
    String uid,
    Map<String, dynamic> fields,
  ) async {
    await _firestore.collection('users').doc(uid).update(fields);
  }

  Future<void> levelUp(AppUser user, int expChange) async {
    final int newLevel = user.level + 1;
    final int newMaxExp = user.maxExp + 5;
    final int newExp = (user.expPoint + expChange) % user.maxExp;
    final int newCoin = user.coin + 5;

    await _updateUserFields(user.uid, {
      'level': newLevel,
      'maxExp': newMaxExp,
      'expPoint': newExp,
      'healthPoint': 100,
      'coin': newCoin,
    });
  }

  Future<void> levelDown(AppUser user) async {
    final int newLevel = user.level > 1 ? user.level - 1 : 1;
    final int newMaxExp = (user.maxExp - 5) > 100 ? user.maxExp - 5 : 100;
    final int newCoin = (user.coin - 3) > 0 ? user.coin - 3 : 0;

    await _updateUserFields(user.uid, {
      'level': newLevel,
      'maxExp': newMaxExp,
      'expPoint': 0,
      'healthPoint': 100,
      'coin': newCoin,
    });
  }
}
