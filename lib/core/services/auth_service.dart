import 'package:firebase_auth/firebase_auth.dart';

// ════════════════════════════════════════════════════════════════════════════
// AuthService — thin wrapper around FirebaseAuth.
//
// All methods use signInWithPopup (web-safe — no redirect needed).
//   • Google    → GoogleAuthProvider
//   • LinkedIn  → OAuthProvider('oidc.linkedin')  [OIDC must be configured
//                  in Firebase Console → Authentication → Sign-in method]
// ════════════════════════════════════════════════════════════════════════════
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Reactive auth state ──────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── Google Sign-In ───────────────────────────────────────────────────────
  Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile')
      ..setCustomParameters({'prompt': 'select_account'});
    return _auth.signInWithPopup(provider);
  }

  // ── LinkedIn (OIDC) Sign-In ──────────────────────────────────────────────
  Future<UserCredential> signInWithLinkedIn() async {
    final provider = OAuthProvider('oidc.linkedin')
      ..addScope('openid')
      ..addScope('profile')
      ..addScope('email');
    return _auth.signInWithPopup(provider);
  }

  // ── Sign-Out ─────────────────────────────────────────────────────────────
  Future<void> signOut() => _auth.signOut();
}
