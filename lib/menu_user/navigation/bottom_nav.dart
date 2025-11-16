import 'package:arunaapp/menu_user/chat/index.dart';
import 'package:arunaapp/menu_user/help/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/index.dart';
import '../settings/index.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex; // 0: home, 1: question, 2: chat, 3: settings

  String _homeGreetingName() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? displayName = user?.displayName;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName;
    }
    return user?.email ?? 'Pengguna';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF76C6D3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 30),
            onPressed: currentIndex == 0
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) =>
                            HomePage(firstName: _homeGreetingName()),
                      ),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 30),
            onPressed: currentIndex == 1
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const HelpPage(),
                      ),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.group, color: Colors.white, size: 30),
            onPressed: currentIndex == 2
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const ChatPage(),
                      ),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: currentIndex == 3
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const SettingPage(),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
