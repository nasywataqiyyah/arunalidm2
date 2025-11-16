import 'package:arunaapp/menu_user/home/game_education_page.dart';
import 'package:arunaapp/menu_user/home/speech_to_sign_language.dart';
import 'package:flutter/material.dart';

import 'text_to_visual.dart';
import '../navigation/bottom_nav.dart';
import '../navigation/header.dart';
import 'speech_to_text_page.dart';

class HomePage extends StatelessWidget {
  final String firstName;

  const HomePage({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: const AppHeader(title: 'Beranda'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $firstName! Mau belajar apa hari ini?',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                children: [
                  buildMenuCard(
                    icon: Icons.mic,
                    title: 'Speech → Text',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpeechToTextPage(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.image,
                    title: 'Text → Visual',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TextVisualPage(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.front_hand,
                    title: 'Speech → Sign Language',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SpeechToSignLanguagePage(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.videogame_asset,
                    title: 'Game Education',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameEducationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
