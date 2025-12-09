import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Email & Password Signup
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user == null) return "Unknown error creating user.";

      // Save to Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed";
    } catch (e) {
      return e.toString();
    }
  }

  /// Email & Password Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  /// Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      // 1. Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google sign-in cancelled";

      // 2. Get Google Auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Build Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user == null) return "Google auth failed";

      // 5. Save user to Firestore IF first-time login
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        });
      }

      return null; // success
    } catch (e) {
      return e.toString();
    }
  }
}
