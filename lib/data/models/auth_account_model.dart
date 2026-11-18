// The Firebase Auth account (not the profile).

enum AuthMethod { google, password }

class AuthAccount {
  const AuthAccount({
    required this.id,
    required this.email,
    required this.method,
    required this.isEmailVerified,
  });

  final String id;
  final String email;
  final AuthMethod method;
  final bool isEmailVerified;

  // Google accounts arrive verified.
  bool get needsEmailVerification =>
      method == AuthMethod.password && !isEmailVerified;

  @override
  bool operator ==(Object other) =>
      other is AuthAccount &&
      other.id == id &&
      other.email == email &&
      other.method == method &&
      other.isEmailVerified == isEmailVerified;

  @override
  int get hashCode => Object.hash(id, email, method, isEmailVerified);
}
