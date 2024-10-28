import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthViewModel with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User aborted the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
         final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", user.uid);
        prefs.setBool("isVerified", user.emailVerified);
        prefs.setBool("isgoogle", true);

        if (!userDoc.exists) {
          // If user doesn't exist, create a new document
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName,
            'email': user.email,
            'userImage': user.photoURL,
          });
        }
      }
   
      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }


  final bool _passwordObsecure = true;
  final bool _isEmailVerified = false;
  bool get passwordObsecure => _passwordObsecure;
  bool get isEmailverified => _isEmailVerified;
  
}
