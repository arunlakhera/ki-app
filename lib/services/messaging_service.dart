import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Initialize ───────────────────────────────────────────────────────────

  Future<void> initialize() async {
    // Request notification permissions
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('FCM: User granted permission');
      await _setupToken();
      _listenToTokenRefresh();
      _setupForegroundHandler();
    } else {
      debugPrint('FCM: User denied permission');
    }
  }

  // ── Token Management ─────────────────────────────────────────────────────

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> _setupToken() async {
    final token = await getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) {
      _saveTokenToFirestore(token);
    });
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).update({
      'fcmToken': token,
      'updatedAt': Timestamp.now(),
    });
  }

  // ── Foreground Messages ──────────────────────────────────────────────────

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground message: ${message.notification?.title}');
      // Handle foreground notification display here
      // You can use flutter_local_notifications to show a notification
      _onMessageReceived(message);
    });
  }

  // ── Background & Terminated Messages ─────────────────────────────────────

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('FCM background message: ${message.notification?.title}');
  }

  void setupInteractionHandlers({
    required void Function(RemoteMessage) onMessageOpenedApp,
  }) {
    // When app is opened from a notification while in background
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);

    // Check if app was opened from a terminated state via notification
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        onMessageOpenedApp(message);
      }
    });
  }

  // ── Topic Subscriptions ──────────────────────────────────────────────────

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  // Subscribe to relevant topics based on user type
  Future<void> subscribeToUserTopics(String userType, List<String> skills) async {
    await subscribeToTopic('all_users');
    await subscribeToTopic(userType); // 'worker' or 'employer'
    for (final skill in skills) {
      await subscribeToTopic('skill_${skill.toLowerCase().replaceAll(' ', '_')}');
    }
  }

  // ── Notification Callback ────────────────────────────────────────────────

  void _onMessageReceived(RemoteMessage message) {
    // Override this in your app to handle notification data
    debugPrint('Notification data: ${message.data}');
  }

  // ── Cleanup ──────────────────────────────────────────────────────────────

  Future<void> clearToken() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).update({
        'fcmToken': null,
        'updatedAt': Timestamp.now(),
      });
    }
    await _messaging.deleteToken();
  }
}
