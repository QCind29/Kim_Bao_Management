import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? _prefs;

  AuthService() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _initPrefs(); // Initialize prefs before using it
      await _prefs!.setBool('isLoggedIn', true);

      return userCredential;

    } catch (e) {
      throw e;
    }
  }

  // Check if user is already signed in
  Future<bool> isUserLoggedIn() async {
    if (_prefs == null) await _initPrefs();
    return _prefs!.getBool('isLoggedIn') ?? false;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (_prefs == null) await _initPrefs();

    await _prefs!.setBool('isLoggedIn', false);
    print("Sign out successfully");
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Future<void> logoutUser() async {
  //   // Sign out from Firebase Auth
  //   await FirebaseAuth.instance.signOut();
  //
  //   // Clear stored authentication data
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(PREF_KEY_TOKEN);
  // }
}
