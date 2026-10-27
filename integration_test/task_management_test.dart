import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buteemjiji/models/task_model.dart';
import 'package:buteemjiji/models/user_model.dart';
import 'package:buteemjiji/services/task_service.dart';
import 'package:buteemjiji/services/user_service.dart';
import 'package:buteemjiji/utils/app_enums.dart';
import 'package:buteemjiji/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String TEST_EMAIL = 'test_user@example.com';
  const String TEST_PASSWORD = 'test_password123';

  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late TaskService taskService;
  late UserService userService;
  late String testUserId;

  setUpAll(() async {
    try {
      await Firebase.initializeApp(
      );

      auth = FirebaseAuth.instance;
      firestore = FirebaseFirestore.instance;
      taskService = TaskService();
      userService = UserService();

      try {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: TEST_EMAIL,
          password: TEST_PASSWORD,
        );
        testUserId = userCredential.user!.uid;
      } catch (e) {
        try {
          final userCredential = await auth.signInWithEmailAndPassword(
            email: TEST_EMAIL,
            password: TEST_PASSWORD,
          );
          testUserId = userCredential.user!.uid;
        } catch (signInError) {
          print('Error signing in: $signInError');
          rethrow;
        }
      }

      final userDoc = await firestore.collection('users').doc(testUserId).get();
      if (!userDoc.exists) {
        await firestore.collection('users').doc(testUserId).set({
          'uid': testUserId,
          'username': 'Test User',
          'email': TEST_EMAIL,
          'level': 1,
          'expPoint': 0,
          'maxExp': 100,
          'healthPoint': 100,
          'coin': 10,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Setup error: $e');
      rethrow;
    }
  });

  tearDownAll(() async {
    try {
      if (testUserId != null && testUserId.isNotEmpty) {
        final tasksSnapshot = await firestore
            .collection('tasks')
            .where('uid', isEqualTo: testUserId)
            .get();

        for (final doc in tasksSnapshot.docs) {
          await firestore.collection('tasks').doc(doc.id).delete();
        }
        print('Cleaned up ${tasksSnapshot.docs.length} test tasks');

        await auth.signOut();
        print('Signed out test user');
      }
    } catch (e) {
      print('Teardown error: $e');
    }
  });

  group('Task Management Integration Tests', () {
    String? habitTaskId;
    String? dailyTaskId;
    String? todoTaskId;
    String? rewardTaskId;

    test('1. Create different types of tasks', () async {
      final habitTask = Task(
        taskId: '',
        uid: testUserId,
        type: TaskType.habit,
        title: 'Test Habit',
        categoryIds: ['health'],
        difficulty: Difficulty.medium,
        isPositive: true,
      );

      final createdHabitTask = await taskService.createTask(habitTask);
      habitTaskId = createdHabitTask.taskId;

      expect(createdHabitTask.taskId.isEmpty, isFalse);
      expect(createdHabitTask.title, equals('Test Habit'));
      expect(createdHabitTask.type, equals(TaskType.habit));

      final dailyTask = Task(
        taskId: '',
        uid: testUserId,
        type: TaskType.daily,
        title: 'Test Daily',
        categoryIds: ['work'],
        difficulty: Difficulty.easy,
        repeat: RepeatInterval.daily,
        interval: 1,
        isCompleted: false,
        lastCompletedDate: DateTime.now().subtract(Duration(days: 1)),
      );

      final createdDailyTask = await taskService.createTask(dailyTask);
      dailyTaskId = createdDailyTask.taskId;

      expect(createdDailyTask.taskId.isEmpty, isFalse);
      expect(createdDailyTask.title, equals('Test Daily'));
      expect(createdDailyTask.type, equals(TaskType.daily));

      final todoTask = Task(
        taskId: '',
        uid: testUserId,
        type: TaskType.todo,
        title: 'Test Todo',
        categoryIds: ['personal'],
        difficulty: Difficulty.hard,
        isCompleted: false,
        dueDate: DateTime.now().add(Duration(days: 1)),
        lastCompletedDate: null,
      );

      final createdTodoTask = await taskService.createTask(todoTask);
      todoTaskId = createdTodoTask.taskId;

      expect(createdTodoTask.taskId.isEmpty, isFalse);
      expect(createdTodoTask.title, equals('Test Todo'));
      expect(createdTodoTask.type, equals(TaskType.todo));

      final rewardTask = Task(
        taskId: '',
        uid: testUserId,
        type: TaskType.reward,
        title: 'Test Reward',
        categoryIds: ['leisure'],
        cost: 20,
      );

      final createdRewardTask = await taskService.createTask(rewardTask);
      rewardTaskId = createdRewardTask.taskId;

      expect(createdRewardTask.taskId.isEmpty, isFalse);
      expect(createdRewardTask.title, equals('Test Reward'));
      expect(createdRewardTask.type, equals(TaskType.reward));
      expect(createdRewardTask.cost, equals(20));

      final habitDoc = await firestore.collection('tasks').doc(habitTaskId).get();
      final dailyDoc = await firestore.collection('tasks').doc(dailyTaskId).get();
      final todoDoc = await firestore.collection('tasks').doc(todoTaskId).get();
      final rewardDoc = await firestore.collection('tasks').doc(rewardTaskId).get();

      expect(habitDoc.exists, isTrue);
      expect(dailyDoc.exists, isTrue);
      expect(todoDoc.exists, isTrue);
      expect(rewardDoc.exists, isTrue);
    });
  });
}