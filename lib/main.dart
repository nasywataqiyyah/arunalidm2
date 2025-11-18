import 'dart:async';

import 'package:arunaapp/auth_storage.dart';
import 'package:arunaapp/logo_app.dart';
import 'package:arunaapp/user/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:arunaapp/firebase_options.dart';

// ⚠️ Tambahkan ini
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ⚠️ Tambahkan ini agar DateFormat('id_ID') tidak error
  await initializeDateFormatting('id_ID', null);

  runApp(await Arunaapp.initialize());
}

class Arunaapp extends StatefulWidget {
  final String? authToken;

  Arunaapp({this.authToken});

  static Future<Arunaapp> initialize() async {
    String? token = await AuthStorage.getToken();
    return Arunaapp(authToken: token);
  }

  @override
  State<Arunaapp> createState() => _ArunaappState();
}

class _ArunaappState extends State<Arunaapp> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _startTimeout();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimeout() {
    const timeout = Duration(minutes: 30);
    _timer = Timer(timeout, _handleTimeout);
  }

  void _restartTimeout() {
    if (!kIsWeb) {
      _timer?.cancel();
      _startTimeout();
    }
  }

  void _handleTimeout() async {
    await AuthStorage.clearToken();
    _handleLogout();
  }

  Future<void> _handleLogout() async {
    await AuthStorage.clearToken();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SignIn()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aruna App',
      themeMode: ThemeMode.system,

      home: widget.authToken == null ? LogoApp() : SignIn(),

      builder: (context, child) {
        _restartTimeout();
        return child!;
      },
    );
  }
}
