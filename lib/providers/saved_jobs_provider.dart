import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_model.dart';

class SavedJobsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<JobModel> _savedJobs = [];
  bool _isLoading = false;

  List<JobModel> get savedJobs => _savedJobs;
  bool get isLoading => _isLoading;

  bool isJobSaved(String jobId) {
    return _savedJobs.any((job) => job.id == jobId);
  }

  Future<void> loadSavedJobs() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_jobs')
          .get();

      _savedJobs.clear();
      for (var doc in snapshot.docs) {
        _savedJobs.add(JobModel.fromJson(doc.data()));
      }
    } catch (e) {
      debugPrint('Error loading saved jobs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleSaveJob(JobModel job) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final isSaved = isJobSaved(job.id);

      if (isSaved) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('saved_jobs')
            .doc(job.id)
            .delete();

        _savedJobs.removeWhere((j) => j.id == job.id);
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('saved_jobs')
            .doc(job.id)
            .set(job.toJson());

        _savedJobs.add(job);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error toggling saved job: $e');
      return false;
    }
  }
}
