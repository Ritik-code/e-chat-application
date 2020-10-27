import 'package:firebase_auth/firebase_auth.dart';

class UserProfileInformation {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//check for current password when user wants to change password
  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
