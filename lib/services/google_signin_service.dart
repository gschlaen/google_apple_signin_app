import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final googleKey = await account?.authentication;

      // print(account);
      // print('====== ID TOKEN ======');
      // print(googleKey?.idToken);

      final signInWithGoogleEndpoint = Uri(
        scheme: 'https',
        host: 'google-apple-sign-in-backend.herokuapp.com',
        path: '/google',
      );

      final session = await http.post(
        signInWithGoogleEndpoint,
        body: {
          'token': googleKey?.idToken,
        },
      );
      print('=====BACKEND=====');
      print(session.body);

      return account;
    } catch (e) {
      print('Error in Google Signin');
      print(e.toString());
      return null;
    }
  }

  static Future<GoogleSignInAccount?> signOut() async {
    await _googleSignIn.signOut();
  }
}
