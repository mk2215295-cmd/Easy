import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// AuthState — exhaustive authentication lifecycle enum
// ════════════════════════════════════════════════════════════════════════════
enum AuthState { loading, authenticated, unauthenticated }

// ════════════════════════════════════════════════════════════════════════════
// AppAuthProvider — ChangeNotifier wrapping AuthService.
//
// Used as GoRouter refreshListenable so route guards re-evaluate on every
// auth state change without manual triggers.
// ════════════════════════════════════════════════════════════════════════════
class AppAuthProvider extends ChangeNotifier {
  AppAuthProvider() {
    _sub = AuthService.instance.authStateChanges.listen(_onAuthChanged);
  }

  late final StreamSubscription<User?> _sub;

  AuthState _state = AuthState.loading;
  AuthUser? _currentUser;
  bool _isBusy = false;
  String? _errorMessage;

  // ── Public getters ───────────────────────────────────────────────────────
  AuthState get state => _state;
  AuthUser? get currentUser => _currentUser;
  bool get isBusy => _isBusy;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;
  String? get errorMessage => _errorMessage;

  // ── Internal listener ────────────────────────────────────────────────────
  void _onAuthChanged(User? firebaseUser) {
    if (firebaseUser == null) {
      _state = AuthState.unauthenticated;
      _currentUser = null;
    } else {
      _state = AuthState.authenticated;
      _currentUser = AuthUser.fromFirebase(firebaseUser);
    }
    notifyListeners();
  }

  // ── Sign-in actions ──────────────────────────────────────────────────────
  Future<void> signInWithGoogle() => _doSignIn(AuthService.instance.signInWithGoogle);
  Future<void> signInWithLinkedIn() => _doSignIn(AuthService.instance.signInWithLinkedIn);

  Future<void> _doSignIn(Future<UserCredential> Function() action) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      await action();
      // _onAuthChanged handles state update via stream
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendly(e);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
    } finally {
      _setBusy(false);
    }
  }

  // ── Sign-out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    _setBusy(true);
    await AuthService.instance.signOut();
    _setBusy(false);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  void _setBusy(bool v) {
    _isBusy = v;
    notifyListeners();
  }

  String _friendly(FirebaseAuthException e) {
    switch (e.code) {
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      case 'popup-blocked':
        return 'Popup blocked. Please allow popups for this site.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different provider.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
