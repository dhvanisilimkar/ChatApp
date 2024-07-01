import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthHepler {
  AuthHepler._();

  static final AuthHepler authHepler = AuthHepler._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Logger logger = Logger();

  Future<void> anonimously() async {
    await firebaseAuth.signInAnonymously();
  }

  Future<User?> registerUser({
    required String emial,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: emial, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The Password is too weak");
      } else if (e.code == 'email-already-in-use') {
        print("The account already exists for the email");
      }
    } catch (e) {
      print(e);
    }
    return userCredential?.user;
  }

  Future<User?> userSignUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    print("Email :- $email , Password :- $password");
    UserCredential? credential;

    try {
      credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found ') {
        print("Not User Found");
      } else if (e.code == 'wrong-found') {
        print("wrong password provider for that user");
      }
    }
    return credential?.user;
  }

  Future<void> Signout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<User?> SignInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    try {
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication!.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        ),
      );
      logger.i("Succes....!");
      return userCredential.user;
    } catch (e) {
      logger.i("ERROR :- $e");
      return null;
    }
  }

  forgetPassword({required String email}) {
    firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
