<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class AuthStorage {

  /// Simpan token
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      html.window.localStorage['authToken'] = token;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
    }
  }

  /// Ambil token
  static Future<String?> getToken() async {
    if (kIsWeb) {
      return html.window.localStorage['authToken'];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('authToken');
    }
  }

  /// Hapus token
  static Future<void> clearToken() async {
    if (kIsWeb) {
      html.window.localStorage.remove('authToken');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
    }
  }
}
=======
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {

  /// SIMPAN TOKEN
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  /// AMBIL TOKEN
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// HAPUS TOKEN
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}

>>>>>>> origin/nasywa
