import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextVisualPage extends StatefulWidget {
  const TextVisualPage({super.key});

  @override
  State<TextVisualPage> createState() => _TextVisualPageState();
}

class _TextVisualPageState extends State<TextVisualPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _saveToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('text_inputs').add({
        'text': _controller.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teks berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToNextPage() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan teks terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await _saveToFirebase();

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TextVisual2Page(text: _controller.text.trim()),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A82A0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Text to Visual',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/profile_icon.png"),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ========== TITLE ==========
              const Text(
                'Masukkan Teks untuk Visualisasi',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // ========== TEXT FIELD CARD ==========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Ketik sesuatu...",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ========== BUTTON ENTER ==========
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // ========== BOTTOM NAV BAR ==========
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: const Color(0xFF6EC5D2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 32),
            Icon(Icons.help_outline, color: Colors.white, size: 32),
            Icon(Icons.group, color: Colors.white, size: 32),
            Icon(Icons.settings, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}
