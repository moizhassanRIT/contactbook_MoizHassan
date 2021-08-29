import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationService{

  Future<bool> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password);
      return true;
    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        return false;
    }

  }

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}


}