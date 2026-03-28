import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_model.dart';

class SettingsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationPreferences _preferences = NotificationPreferences();
  bool _isLoading = false;

  NotificationPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;

  static const List<Map<String, String>> availableCountries = [
    {'key': 'germany', 'name': 'ألمانيا', 'flag': '🇩🇪'},
    {'key': 'france', 'name': 'فرنسا', 'flag': '🇫🇷'},
    {'key': 'netherlands', 'name': 'هولندا', 'flag': '🇳🇱'},
    {'key': 'italy', 'name': 'إيطاليا', 'flag': '🇮🇹'},
    {'key': 'spain', 'name': 'إسبانيا', 'flag': '🇪🇸'},
    {'key': 'sweden', 'name': 'السويد', 'flag': '🇸🇪'},
    {'key': 'austria', 'name': 'النمسا', 'flag': '🇦🇹'},
    {'key': 'belgium', 'name': 'بلجيكا', 'flag': '🇧🇪'},
    {'key': 'poland', 'name': 'بولندا', 'flag': '🇵🇱'},
  ];

  Future<void> loadPreferences() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['notificationPreferences'] != null) {
          _preferences = NotificationPreferences.fromJson(
            data['notificationPreferences'],
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleNewJobs(bool enabled) async {
    _preferences = _preferences.copyWith(newJobsEnabled: enabled);
    notifyListeners();
    await _savePreferences();

    if (enabled) {
      await _subscribeToTopics();
    } else {
      await _unsubscribeFromAllTopics();
    }
  }

  Future<void> toggleCountry(String country, bool selected) async {
    final countries = List<String>.from(_preferences.targetCountries);

    if (selected && !countries.contains(country)) {
      countries.add(country);
      await _messaging.subscribeToTopic('jobs_$country');
    } else if (!selected && countries.contains(country)) {
      countries.remove(country);
      await _messaging.unsubscribeFromTopic('jobs_$country');
    }

    _preferences = _preferences.copyWith(targetCountries: countries);
    notifyListeners();
    await _savePreferences();
  }

  Future<void> toggleJobType(String jobType, bool selected) async {
    final types = List<String>.from(_preferences.jobTypes);

    if (selected && !types.contains(jobType)) {
      types.add(jobType);
    } else if (!selected && types.contains(jobType)) {
      types.remove(jobType);
    }

    _preferences = _preferences.copyWith(jobTypes: types);
    notifyListeners();
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'notificationPreferences': _preferences.toJson(),
      });
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  Future<void> _subscribeToTopics() async {
    await _messaging.subscribeToTopic('new_jobs');

    for (final country in _preferences.targetCountries) {
      await _messaging.subscribeToTopic('jobs_$country');
    }
  }

  Future<void> _unsubscribeFromAllTopics() async {
    await _messaging.unsubscribeFromTopic('new_jobs');

    for (final country in _preferences.targetCountries) {
      await _messaging.unsubscribeFromTopic('jobs_$country');
    }
  }
}
