import 'package:arunaapp/user/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../navigation/bottom_nav.dart';
import '../navigation/header.dart';
import 'update_account.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: const AppHeader(title: 'Pengaturan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            // =================== PROFILE SECTION ===================
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: (user == null)
                  ? const Stream.empty()
                  : FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() ?? <String, dynamic>{};
                final String firestoreDisplayName =
                    (data['display_name'] as String?)?.trim() ?? '';
                final String fromNames =
                    ('${(data['first_name'] ?? '').toString()} ${(data['last_name'] ?? '').toString()}')
                        .trim();
                final String authDisplayName =
                    (user?.displayName?.trim().isNotEmpty == true)
                    ? user!.displayName!
                    : '';
                final String email =
                    user?.email ?? (data['email'] as String?) ?? '-';
                final String displayName = firestoreDisplayName.isNotEmpty
                    ? firestoreDisplayName
                    : (fromNames.isNotEmpty
                          ? fromNames
                          : (authDisplayName.isNotEmpty
                                ? authDisplayName
                                : 'Pengguna'));
                final String? photoUrl =
                    user?.photoURL ?? (data['photo_url'] as String?);

                final ImageProvider<Object> avatarProvider =
                    (photoUrl != null && photoUrl.isNotEmpty)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/images/profile_icon.png');

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: avatarProvider,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: Colors.white24,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            // =================== MENU ITEMS ===================
            SettingItem(
              icon: Icons.key,
              title: 'Akun',
              subtitle: 'Edit profil, Kata sandi, Email/ No.Hp, Keamanan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdateAccountPage()),
                );
              },
            ),
            const SettingItem(
              icon: Icons.settings_suggest_outlined,
              title: 'Preferensi',
              subtitle: 'Bahasa isyarat, Audio, Subtitle/Teks, Tema',
            ),
            const SettingItem(
              icon: Icons.tune,
              title: 'Setelan Sistem',
              subtitle: 'Notifikasi, Panduan, Bahasa Aplikasi',
            ),
            const SettingItem(
              icon: Icons.more_horiz,
              title: 'Lainnya',
              subtitle: 'Tentang Aruna, Kebijakan Privasi',
            ),

            const SizedBox(height: 30),

            // =================== LOGOUT BUTTON ===================
            ElevatedButton.icon(
              onPressed: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Yakin ingin keluar dari akun?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Keluar'),
                        ),
                      ],
                    );
                  },
                );
                if (confirm != true) return;

                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    pageBuilder: (_, __, ___) => const SignIn(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

// =================== CUSTOM WIDGET ===================
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(
          0xFF4DA3D4,
        ).withValues(alpha: 0.3), // 💙 biru transparan
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(
              0xFF4DA3D4,
            ).withValues(alpha: 0.5), // 💙 biru terang
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
