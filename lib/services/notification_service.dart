import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initialize() async {
    final permission = await _fcm.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _fcm.getToken();
      debugPrint('🔥 FCM Token: $token');
      await _saveTokenToFirestore(token);
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;
    await _db.collection('fcm_tokens').doc(token).set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': 'mobile',
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📩 Foreground message: ${message.notification?.title}');
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('👆 Message opened from notification: ${message.data}');
  }

  void _showLocalNotification(RemoteMessage message) {
    // Local notification logic using flutter_local_notifications
    // This would integrate with flutter_local_notifications package
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('❌ Unsubscribed from topic: $topic');
  }

  Future<void> sendPushNotification({
    required String title,
    required String body,
    required String userId,
    Map<String, dynamic>? data,
  }) async {
    final docRef = _db.collection('notifications').doc();
    await docRef.set({
      'title': title,
      'body': body,
      'userId': userId,
      'data': data ?? {},
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
      'type': 'push',
    });
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    final snapshot = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'read': true,
    });
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    final snapshot = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  Stream<DocumentSnapshot> watchUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  static const Map<String, String> notificationTypes = {
    'application': 'تقديم على وظيفة',
    'interview': 'دعوة لمقابلة',
    'accepted': 'قبول',
    'rejected': 'رفض',
    'cv_viewed': 'مشاهدة السيرة الذاتية',
    'system': 'إشعار النظام',
  };

  String getNotificationTypearb(String type) {
    return notificationTypes[type] ?? 'إشعار';
  }
}
