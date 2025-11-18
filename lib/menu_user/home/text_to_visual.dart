import 'package:flutter/material.dart';

class TextVisualPage extends StatefulWidget {
  const TextVisualPage({super.key});

  @override
  State<TextVisualPage> createState() => _TextVisualPageState();
}

class _TextVisualPageState extends State<TextVisualPage> {
  final TextEditingController _controller = TextEditingController();

  // daftar semua gambar yang ada di asset
  final Map<String, String> imageMap = {
    "anggur": "assets/images/anggur.png",
    "anjing": "assets/images/anjing.png",
    "apel": "assets/images/apel.png",
    "ayam": "assets/images/ayam.png",
    "bawang": "assets/images/bawang.png",
    "bayam": "assets/images/bayam.png",
    "benda": "assets/images/benda.png",
    "brokoli": "assets/images/brokoli.png",
    "buah": "assets/images/buah.png",
    "buku": "assets/images/buku.png",
    "burung": "assets/images/burung.png",
    "cabai": "assets/images/cabai.png",
    "gajah": "assets/images/gajah.png",
    "gelas": "assets/images/gelas.png",
    "ikan": "assets/images/ikan.png",
    "jam": "assets/images/jam.png",
    "jeruk": "assets/images/jeruk.png",
    "kol": "assets/images/kol.png",
    "kucing": "assets/images/kucing.png",
    "kursi": "assets/images/kursi.png",
    "mangga": "assets/images/mangga.png",
    "meja": "assets/images/meja.png",
    "mentimun": "assets/images/mentimun.png",
    "pensil": "assets/images/pensil.png",
    "pepaya": "assets/images/pepaya.png",
    "pir": "assets/images/pir.png",
    "piring": "assets/images/piring.png",
    "pisang": "assets/images/pisang.png",
    "sapi": "assets/images/sapi.png",
    "sayur": "assets/images/sayur.png",
    "semangka": "assets/images/semangka.png",
    "singa": "assets/images/singa.png",
    "tas": "assets/images/tas.png",
    "terong": "assets/images/terong.png",
    "tomat": "assets/images/tomat.png",
    "wortel": "assets/images/wortel.png",
    "notfound": "assets/images/notfound.png",
  };

  String? selectedImage; // gambar yang ditampilkan

  void showImageFromText() {
    String input = _controller.text.trim().toLowerCase();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Masukkan teks terlebih dahulu!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      if (imageMap.containsKey(input)) {
        selectedImage = imageMap[input];
      } else {
        selectedImage = imageMap["notfound"];
      }
    });
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
          "Text to Visual",
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

              const Text(
                "Masukkan nama gambar\ncontoh: kucing, apel, pisang…",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // TEXT FIELD
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

              const SizedBox(height: 30),

              // BUTTON LANJUTKAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: showImageFromText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Lihat Gambar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // GAMBAR
              if (selectedImage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset(
                    selectedImage!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
