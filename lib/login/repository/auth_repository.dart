/*
* AuthRepository : Singleton Class which provides access to methods for sign in with 
*                  Google, Facebook and Twitter and returns FirebaseUser Object.
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  static final _repository = AuthRepository._singleton();

  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  /* 
  * Factory Constructor which provides Single AuthRepository Object
  */
  factory AuthRepository() {
    return _repository;
  }

  AuthRepository._singleton();
  
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    return user;
  }
}
