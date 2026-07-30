import 'package:firebase_auth/firebase_auth.dart';

// ════════════════════════════════════════════════════════════════════════════
// AuthUser — thin immutable value object decoupling UI from firebase_auth.User
// ════════════════════════════════════════════════════════════════════════════
class AuthUser {
  const AuthUser({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.provider,
  });

  final String id;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  /// 'google.com' | 'oidc.linkedin' | etc.
  final String? provider;

  factory AuthUser.fromFirebase(User user) {
    final providerData = user.providerData;
    final provider = providerData.isNotEmpty ? providerData.first.providerId : null;
    return AuthUser(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      provider: provider,
    );
  }

  /// Returns up-to-2-character initials for the avatar fallback.
  String get initials {
    final name = displayName?.trim();
    if (name == null || name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  String toString() => 'AuthUser(id: $id, name: $displayName, email: $email)';
}
