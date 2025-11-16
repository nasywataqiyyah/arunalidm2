import 'package:flutter/material.dart';
import '../navigation/bottom_nav.dart';
import '../navigation/header.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        'name': 'Eren Yeager',
        'message': 'Hai apa kabar ?',
        'time': '13.09',
        'icon': 'person',
      },
      {
        'name': 'Mikasa Acke',
        'message': 'Selamat Pagi',
        'time': '08.00',
        'icon': 'person',
      },
      {
        'name': 'Grup guru slb',
        'message': '+62.01123456: halo',
        'time': '06.56',
        'icon': 'group',
      },
      {
        'name': 'Mabar Kuy!',
        'message': 'Reyroblok: P mabar',
        'time': 'Yesterday',
        'icon': 'group',
      },
      {
        'name': 'Akilajamet',
        'message': 'Apa Pr kemarin?',
        'time': 'Yesterday',
        'icon': 'person',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: const AppHeader(title: 'Komunitas'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xF2FFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(
                    chat['icon'] == 'group' ? Icons.group : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  chat['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(chat['message']!),
                trailing: Text(
                  chat['time']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         ChatDetailPage(chatName: chat['name']!),
                  //   ),
                  // );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}


