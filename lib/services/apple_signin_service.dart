import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService {
  static String clienId = 'com.fernandoherrera.signinservice';
  static String redirectUri = 'https://apple-google-sign-in.herokuapp.com/callbacks/sign_in_with_apple';

  static void sigIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: clienId,
            redirectUri: Uri.parse(redirectUri),
          ));

      print(credential);
      print(credential.authorizationCode);

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
      final signInWuthAppleEndpoint = Uri(
        scheme: 'https',
        host: 'google-apple-sign-in-backend.herokuapp.com',
        path: '/sign_in_with_apple',
        queryParameters: {
          'code': credential.authorizationCode,
          'fisrtName': credential.givenName,
          'lastName': credential.familyName,
          'useBundleId': Platform.isIOS ? 'true' : 'false',
          if (credential.state != null) 'state': credential.state,
        },
      );

      final session = await http.post(signInWuthAppleEndpoint);

      print('Respuesta de mi servicio');
      print(session.body);
    } catch (e) {
      print('Error en signin');
      print(e.toString());
    }
  }
}
