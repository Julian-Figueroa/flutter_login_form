import 'dart:convert';
// import 'dart:io';

import 'package:formvalidation/src/shared/user_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

class UserProvider {
  final _firebaseAPIKey = 'AIzaSyC5syLynAJs16Auy7K_35xBAQrEMGh-PbI';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseAPIKey';
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      
      return {
        'ok': true,
        'token': decodedResp['idToken'],
      };
    } else {
      return {
        'ok': false,
        'message': decodedResp['error']['message'],
      };
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$_firebaseAPIKey';
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      
      return {
        'ok': true,
        'token': decodedResp['idToken'],
      };
    } else {
      return {
        'ok': false,
        'message': decodedResp['error']['message'],
      };
    }
  }
}
