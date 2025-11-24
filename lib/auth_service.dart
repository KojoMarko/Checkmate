
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;

  Stream<User?> get userChanges => _auth.authStateChanges();

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e, s) {
      developer.log('Google Sign-in failed', name: 'com.checkmate.auth', error: e, stackTrace: s);
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      developer.log('Email/Password Sign-in failed', name: 'com.checkmate.auth', error: e);
      rethrow;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      developer.log('Email/Password Sign-up failed', name: 'com.checkmate.auth', error: e);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      developer.log('Password reset email failed', name: 'com.checkmate.auth', error: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    // It's good practice to sign out from each provider
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        developer.log('Successfully signed out from Google.', name: 'com.checkmate.auth');
      }
    } catch (e, s) {
      developer.log('Error signing out from Google.', name: 'com.checkmate.auth', error: e, stackTrace: s);
    }

    try {
      await _auth.signOut();
      developer.log('Successfully signed out from Firebase Auth.', name: 'com.checkmate.auth');
    } catch (e, s) {
      developer.log('Error signing out from Firebase Auth.', name: 'com.checkmate.auth', error: e, stackTrace: s);
    }
  }
}
