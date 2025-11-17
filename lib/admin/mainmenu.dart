import 'package:flutter/material.dart';

class Mainmenu extends StatefulWidget {
  const Mainmenu({super.key});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Menu Utama",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ============= GRID MENU =============
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  menuCard(
                    icon: Icons.dashboard,
                    title: "Dashboard",
                    onTap: () {
                      // TODO: halaman dashboard
                    },
                  ),
                  menuCard(
                    icon: Icons.people,
                    title: "Manajemen Akun",
                    onTap: () {
                      // TODO: halaman manajemen akun
                    },
                  ),
                  menuCard(
                    icon: Icons.settings,
                    title: "Pengaturan",
                    onTap: () {
                      // TODO: halaman pengaturan
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ============================
  // CARD MENU WIDGET
  // ============================
  Widget menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 45, color: Colors.blue),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
