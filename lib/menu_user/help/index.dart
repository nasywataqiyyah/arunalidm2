import 'package:flutter/material.dart';

import '../navigation/bottom_nav.dart';
import '../navigation/header.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: const AppHeader(title: 'Bantuan'),
      body: const Center(
        child: Text('Pusat Bantuan', style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
