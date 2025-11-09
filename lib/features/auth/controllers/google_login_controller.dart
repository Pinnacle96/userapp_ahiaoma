import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? googleAccount;
  late GoogleSignInClientAuthorization? auth;

  Future<void> login() async {
    // New google_sign_in API requires serverClientId on BOTH Android and iOS
    await _googleSignIn.initialize(
      serverClientId: AppConstants.googleServerClientId,
    );

    googleAccount = await _googleSignIn.authenticate();
    if (googleAccount == null) {
      // user cancelled
      notifyListeners();
      return;
    }

    const scopes = <String>['email'];
    auth = await googleAccount!.authorizationClient.authorizationForScopes(scopes);

    notifyListeners();
  }
}
