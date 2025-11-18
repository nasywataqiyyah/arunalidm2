import 'dart:math';
import 'package:flutter/material.dart';

class GameEducationPage extends StatefulWidget {
  const GameEducationPage({super.key});

  @override
  State<GameEducationPage> createState() => _GameEducationPageState();
}

class _GameEducationPageState extends State<GameEducationPage> {
  String currentPage = "kategori";
  String typedAnswer = "";
<<<<<<< HEAD

  final List<Map<String, String>> animalBank = [
    {"name": "KUCING", "image": "kucing.png"},
    {"name": "IKAN", "image": "ikan.png"},
    {"name": "BURUNG", "image": "burung.png"},
  ];

  String currentWord = "";
  String currentImage = "";
  List<String> masked = [];
=======
  String answerStatus = ""; // "", "benar", "salah" - untuk feedback visual singkat

  // bank kata sesuai daftar (8 per kategori)
  final Map<String, List<Map<String, String>>> wordBanks = {
    "hewan": [
      {"name": "KUCING", "image": "kucing.png"},
      {"name": "ANJING", "image": "anjing.png"},
      {"name": "IKAN", "image": "ikan.png"},
      {"name": "BURUNG", "image": "burung.png"},
      {"name": "GAJAH", "image": "gajah.png"},
      {"name": "SINGA", "image": "singa.png"},
      {"name": "AYAM", "image": "ayam.png"},
      {"name": "SAPI", "image": "sapi.png"},
    ],
    "buah": [
      {"name": "APEL", "image": "apel.png"},
      {"name": "JERUK", "image": "jeruk.png"},
      {"name": "PISANG", "image": "pisang.png"},
      {"name": "ANGGUR", "image": "anggur.png"},
      {"name": "SEMANGKA", "image": "semangka.png"},
      {"name": "MANGGA", "image": "mangga.png"},
      {"name": "PIR", "image": "pir.png"},
      {"name": "PEPAYA", "image": "pepaya.png"},
    ],
    "sayur": [
      {"name": "WORTEL", "image": "wortel.png"},
      {"name": "BROKOLI", "image": "brokoli.png"},
      {"name": "TOMAT", "image": "tomat.png"},
      {"name": "MENTIMUN", "image": "mentimun.png"},
      {"name": "BAYAM", "image": "bayam.png"},
      {"name": "KOL", "image": "kol.png"},
      {"name": "BAWANG", "image": "bawang.png"},
      {"name": "CABAI", "image": "cabai.png"},
    ],
    "benda": [
      {"name": "MEJA", "image": "meja.png"},
      {"name": "KURSI", "image": "kursi.png"},
      {"name": "TAS", "image": "tas.png"},
      {"name": "BUKU", "image": "buku.png"},
      {"name": "PENSIL", "image": "pensil.png"},
      {"name": "GELAS", "image": "gelas.png"},
      {"name": "PIRING", "image": "piring.png"},
      {"name": "JAM", "image": "jam.png"},
    ],
  };

  // state tebak kata sebelumnya (panjang versi asli)
  String currentCategory = "hewan";
  String currentDifficulty = "mudah"; // mudah, sedang, sulit
  String currentWord = "";
  String currentImage = "";
  List<String> masked = [];
  int attemptsLeft = 0;
>>>>>>> origin/nasywa

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    startTebakKataHewan();
=======
    // tidak otomatis memulai game; user pilih kategori dulu
>>>>>>> origin/nasywa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BA4CF),
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
<<<<<<< HEAD
            onPressed: () => Navigator.pop(context),
=======
            onPressed: () {
              if (currentPage != "kategori") {
                setState(() {
                  currentPage = "kategori";
                  typedAnswer = "";
                  answerStatus = "";
                });
              } else {
                Navigator.pop(context);
              }
            },
>>>>>>> origin/nasywa
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: getPageContent(),
                ),
              ),
            ),
<<<<<<< HEAD
            // buildBottomNav(),
=======
>>>>>>> origin/nasywa
          ],
        ),
      ),
    );
<<<<<<< HEAD
=======
  }

  Widget getPageContent() {
    switch (currentPage) {
      case "tebakHewan":
        return tebakMenu("Tebak Hewan", "Mengenal Jenis Hewan", "hewan");
      case "belajarHewan":
        return belajarHewanPage();
      case "latihanSoal":
      case "tebakBuah":
        return tebakMenu("Tebak Buah", "Mengenal Jenis Buah", "buah");
      case "tebakSayur":
        return tebakMenu("Tebak Sayur", "Mengenal Jenis Sayur", "sayur");
      case "tebakBenda":
        return tebakMenu("Tebak Benda", "Mengenal Jenis Benda", "benda");
      case "tebakKata":
        return tebakKataPage();
      case "tebakKataHewan":
        return tebakKataPage(); // kompatibilitas
      case "keluar":
      default:
        return kategoriPage();
    }
  }

  Widget kategoriPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Game Education",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text("Pilih kategori",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              kategoriButton("Tebak Hewan", Colors.lightBlue, "tebakHewan", "kucing.png", "hewan"),
              kategoriButton("Tebak Buah", Colors.pinkAccent, "tebakBuah", "apel.png", "buah"),
              kategoriButton("Tebak Sayur", Colors.lightGreen, "tebakSayur", "wortel.png", "sayur"),
              kategoriButton("Tebak Benda", Colors.purpleAccent, "tebakBenda", "meja.png", "benda"),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            "Tips: tekan kategori untuk langsung mulai tebak kata sesuai jenisnya.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget kategoriButton(String title, Color color, String nextPage, String imageName, String categoryKey) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentCategory = categoryKey;
          currentDifficulty = "mudah";
          startTebakKata(category: currentCategory, difficulty: currentDifficulty);
          currentPage = "tebakKata";
          typedAnswer = "";
          answerStatus = "";
        });
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: color.withOpacity(0.95),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/$imageName",
                width: 66,
                height: 66,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 66,
                  height: 66,
                  child: Icon(Icons.image_not_supported, color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tebakMenu(String title, String subtitle, String categoryKey) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Game Education",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 20, color: Colors.white)),
        Text(subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.white70)),
        const SizedBox(height: 20),
        tombolMenu("Mulai Tebak Kata", Colors.orange, () {
          setState(() {
            currentCategory = categoryKey;
            currentDifficulty = "mudah";
            startTebakKata(category: currentCategory, difficulty: currentDifficulty);
            currentPage = "tebakKata";
            typedAnswer = "";
            answerStatus = "";
          });
        }),
        tombolMenu("Belajar (lihat gambar)", Colors.lightGreen, () {
          setState(() {
            currentPage = "belajarHewan";
          });
        }),
        tombolMenu("Kembali", Colors.lightBlue, () {
          setState(() {
            currentPage = "kategori";
          });
        }),
      ],
    );
  }

  Widget tombolMenu(String title, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 240,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget belajarHewanPage() {
    final bank = wordBanks[currentCategory] ?? [];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Belajar (${capitalize(currentCategory)})",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: bank.map((item) => belajarItem(item)).toList(),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                currentPage = "tebakMenu";
              });
            },
            child: const Text("Kembali", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget belajarItem(Map<String, String> item) {
    final label = item["name"] ?? "";
    final img = item["image"] ?? "";
    return Container(
      width: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset("assets/images/$img", width: 90, height: 90, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(
              width: 90,
              height: 90,
              child: Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // keyboard & input used in latihan & tebak kata
  Widget keyboardButton(String label) {
    double width;
    if (label == "SPASI") {
      width = 120;
    } else if (label == "DELETE" || label == "ENTER") {
      width = 70;
    } else {
      width = 36;
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: width,
        height: 36,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (label == "DELETE") {
                if (typedAnswer.isNotEmpty) {
                  typedAnswer =
                      typedAnswer.substring(0, typedAnswer.length - 1);
                }
              } else if (label == "SPASI") {
                typedAnswer += " ";
              } else if (label == "ENTER") {
                if (currentPage == "tebakKata") {
                  submitTebakKata();
                }
              } else {
                typedAnswer += label;
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade200,
            padding: EdgeInsets.zero,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 12)),
        ),
      ),
    );
  }

  // halaman utama tebak kata (umum untuk semua kategori)
  Widget tebakKataPage() {
    final rows = [
      "ABCDEF".split(''),
      "GHIJKL".split(''),
      "MNOPQR".split(''),
      "STUVWX".split(''),
      "YZ".split(''),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tebak Kata (${capitalize(currentCategory)})",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              difficultyButton("Mudah", "mudah"),
              const SizedBox(width: 8),
              difficultyButton("Sedang", "sedang"),
              const SizedBox(width: 8),
              difficultyButton("Sulit", "sulit"),
            ],
          ),
          const SizedBox(height: 8),
          Text("Tingkat: ${capitalize(currentDifficulty)}  •  Percobaan tersisa: $attemptsLeft",
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 12),
          const Text("Lihat gambarnya, lalu ketik kata yang benar.",
              style: TextStyle(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: answerStatus == "benar"
                  ? Colors.green.withOpacity(0.45)
                  : answerStatus == "salah"
                  ? Colors.red.withOpacity(0.45)
                  : Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (answerStatus == "benar")
                  const Text("Benar!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                if (answerStatus == "salah")
                  const Text("Salah!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 8),
                if (currentImage.isNotEmpty)
                  Image.asset("assets/images/$currentImage",
                      width: 160, height: 160, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        height: 160,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ))
                else
                  Container(
                    width: 160,
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("No Image"),
                  ),
                const SizedBox(height: 12),
                Text(
                  masked.join(' '),
                  style: const TextStyle(
                      fontSize: 28, letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    typedAnswer.isEmpty ? "_" : typedAnswer,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          startTebakKata(category: currentCategory, difficulty: currentDifficulty);
                          typedAnswer = "";
                          answerStatus = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text("Acak Lagi"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < masked.length; i++) {
                            if (masked[i] == '_') {
                              masked[i] = currentWord[i];
                              break;
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text("Hint"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (var row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: row.map((e) => keyboardButton(e)).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    keyboardButton("SPASI"),
                    const SizedBox(width: 8),
                    keyboardButton("DELETE"),
                    const SizedBox(width: 8),
                    keyboardButton("ENTER"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget difficultyButton(String title, String key) {
    final isSelected = currentDifficulty == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentDifficulty = key;
          startTebakKata(category: currentCategory, difficulty: currentDifficulty);
          typedAnswer = "";
          answerStatus = "";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.95) : Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(title, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
      ),
    );
  }

  // mulai tebak kata berdasarkan kategori + difficulty (otomatis filter panjang nama)
  void startTebakKata({required String category, required String difficulty}) {
    final bank = wordBanks[category] ?? [];
    final r = Random();

    // tentukan range panjang kata berdasarkan difficulty
    int minLen = 1;
    int maxLen = 100;
    if (difficulty == "mudah") {
      minLen = 2;
      maxLen = 4;
      attemptsLeft = 6;
    } else if (difficulty == "sedang") {
      minLen = 5;
      maxLen = 6;
      attemptsLeft = 4;
    } else { // sulit
      minLen = 7;
      maxLen = 100;
      attemptsLeft = 3;
    }

    final filtered = bank.where((m) {
      final len = (m["name"] ?? "").replaceAll(' ', '').length;
      return len >= minLen && len <= maxLen;
    }).toList();

    final choiceList = filtered.isNotEmpty ? filtered : bank;
    if (choiceList.isEmpty) {
      currentWord = "HELLO";
      currentImage = "";
    } else {
      final choice = choiceList[r.nextInt(choiceList.length)];
      currentWord = (choice["name"] ?? "HELLO").toUpperCase();
      currentImage = choice["image"] ?? "";
    }

    masked = currentWord.split('').map((c) => c == ' ' ? ' ' : '_').toList();

    // reveal 1 letter untuk mudah
    if (difficulty == "mudah") {
      final indices = List<int>.generate(currentWord.length, (i) => i).where((i) => currentWord[i] != ' ').toList();
      if (indices.isNotEmpty) {
        final idx = indices[r.nextInt(indices.length)];
        masked[idx] = currentWord[idx];
      }
    }

    currentCategory = category;
    currentDifficulty = difficulty;
    typedAnswer = "";
    answerStatus = "";
  }

  void submitTebakKata() {
    final guess = typedAnswer.trim().toUpperCase();
    if (guess.isEmpty) {
      showResultDialog("Ketik jawaban terlebih dulu!");
      return;
    }

    if (guess == currentWord) {
      // benar -> visual "benar" singkat, tampilkan semua huruf, panggil dialog/nex
      setState(() {
        answerStatus = "benar";
        for (int i = 0; i < masked.length; i++) masked[i] = currentWord[i];
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        setState(() {
          answerStatus = "";
        });
        showResultDialog("Benar! Kata: $currentWord", correct: true);
      });
    } else {
      // salah -> kurangi percobaan & visual "salah" singkat
      setState(() {
        answerStatus = "salah";
        attemptsLeft = (attemptsLeft > 0) ? attemptsLeft - 1 : 0;
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        setState(() {
          answerStatus = "";
        });

        if (attemptsLeft <= 0) {
          showResultDialog("Salah. Percobaan habis. Jawaban benar: $currentWord", correct: false, finished: true);
        } else {
          showResultDialog("Salah. Percobaan tersisa: $attemptsLeft");
        }
      });
    }

    typedAnswer = "";
  }

  void showResultDialog(String message, {bool correct = false, bool finished = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hasil"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (correct || finished) {
                  startTebakKata(category: currentCategory, difficulty: currentDifficulty);
                }
              });
            },
            child: const Text("Oke"),
          ),
          if (correct || finished)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentPage = "kategori";
                });
              },
              child: const Text("Kembali ke kategori"),
            ),
        ],
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
>>>>>>> origin/nasywa
  }


  Widget getPageContent() {
    switch (currentPage) {
      case "tebakHewan":
        return tebakMenu("Tebak Hewan", "Mengenal Jenis Hewan", "belajarHewan");
      case "belajarHewan":
        return belajarHewanPage();
      case "latihanSoal":
        return latihanSoalPage();
      case "tebakBuah":
        return tebakMenu("Tebak Buah", "Mengenal Jenis Buah", "belajarBuah");
      case "tebakSayur":
        return tebakMenu("Tebak Sayur", "Mengenal Jenis Sayur", "belajarSayur");
      case "tebakBenda":
        return tebakMenu("Tebak Benda", "Mengenal Jenis Benda", "belajarBenda");
      case "tebakKataHewan":
        return tebakKataHewanPage();
      case "keluar":
      default:
        return kategoriPage();
    }
  }

  // Widget buildBottomNav() {
  //   return Container(
  //     color: Colors.white.withOpacity(0.2),
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: [
  //           const SizedBox(width: 8),
  //           navButton("Kategori", Icons.list, "kategori"),
  //           const SizedBox(width: 8),
  //           navButton("Tebak Hewan", Icons.pets, "tebakHewan"),
  //           const SizedBox(width: 8),
  //           navButton("Belajar", Icons.school, "belajarHewan"),
  //           const SizedBox(width: 8),
  //           navButton("Latihan", Icons.keyboard, "latihanSoal"),
  //           const SizedBox(width: 8),
  //           navButton("Tebak Kata", Icons.help, "tebakKataHewan"),
  //           const SizedBox(width: 8),
  //           navButton("Keluar", Icons.exit_to_app, "keluar"),
  //           const SizedBox(width: 8),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget navButton(String title, IconData icon, String page) {
    return InkWell(
      onTap: () {
        setState(() {
          currentPage = page;
          typedAnswer = "";
          if (page == "tebakKataHewan") startTebakKataHewan();
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: currentPage == page ? Colors.yellowAccent : Colors.white),
          Text(
            title,
            style: TextStyle(
              color: currentPage == page ? Colors.yellowAccent : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget kategoriPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Game Education",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text("Pilih kategori",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              kategoriButton("Tebak Hewan", Colors.lightBlue, "tebakHewan", "kucing.png"),
              kategoriButton("Tebak Buah", Colors.pinkAccent, "tebakBuah", "buah.jpg"),
              kategoriButton("Tebak Sayur", Colors.lightGreen, "tebakSayur", "sayur.png"),
              kategoriButton("Tebak Benda", Colors.purpleAccent, "tebakBenda", "benda.jpg"),
              kategoriButton("Tebak Kata", Colors.orangeAccent, "tebakKataHewan", "kucing.png"),
            ],
          ),
        ],
      ),
    );
  }

  Widget kategoriButton(String title, Color color, String nextPage, String imageName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = nextPage;
          typedAnswer = "";
          if (nextPage == "tebakKataHewan") startTebakKataHewan();
        });
      },
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/$imageName",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tebakMenu(String title, String subtitle, String belajarPage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Game Education",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 20, color: Colors.white)),
        Text(subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.white70)),
        const SizedBox(height: 20),
        tombolMenu("Mulai Belajar", Colors.lightGreen, belajarPage),
        tombolMenu("Latihan Soal", Colors.orange, "latihanSoal"),
        tombolMenu("Kembali", Colors.lightBlue, "kategori"),
      ],
    );
  }

  Widget tombolMenu(String title, Color color, String nextPage) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 220,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentPage = nextPage;
            typedAnswer = "";
            if (nextPage == "tebakKataHewan") startTebakKataHewan();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget belajarHewanPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Mari Kenali Berbagai Jenis Hewan",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.lightGreenAccent.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hewanItem("kucing.png", "KUCING"),
              hewanItem("ikan.png", "IKAN"),
              hewanItem("burung.png", "BURUNG"),
            ],
          ),
        ),
      ],
    );
  }

  Widget hewanItem(String image, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.asset('assets/images/$image', width: 60, height: 60),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  Widget latihanSoalPage() {
    final rows = [
      "ABCDEF".split(''),
      "GHIJKL".split(''),
      "MNOPQR".split(''),
      "STUVWX".split(''),
      "YZ".split(''),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Perhatikan isyarat dari gambar,\nLalu tebak huruf yang benar!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              typedAnswer.isEmpty ? "_" : typedAnswer,
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                for (var row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: row.map((e) => keyboardButton(e)).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    keyboardButton("SPASI"),
                    const SizedBox(width: 8),
                    keyboardButton("DELETE"),
                    const SizedBox(width: 8),
                    keyboardButton("ENTER"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget keyboardButton(String label) {
    double width;
    if (label == "SPASI") {
      width = 120;
    } else if (label == "DELETE" || label == "ENTER") {
      width = 70;
    } else {
      width = 36;
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: width,
        height: 36,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (label == "DELETE") {
                if (typedAnswer.isNotEmpty) {
                  typedAnswer =
                      typedAnswer.substring(0, typedAnswer.length - 1);
                }
              } else if (label == "SPASI") {
                typedAnswer += " ";
              } else if (label == "ENTER") {
                if (currentPage == "tebakKataHewan") {
                  submitTebakKataHewan();
                } else {
                  currentPage = "belajarHewan";
                }
                typedAnswer = "";
              } else {
                typedAnswer += label;
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade200,
            padding: EdgeInsets.zero,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 12)),
        ),
      ),
    );
  }

  void startTebakKataHewan() {
    final r = Random();
    final choice = animalBank[r.nextInt(animalBank.length)];
    currentWord = choice["name"]!.toUpperCase();
    currentImage = choice["image"]!;
    masked = currentWord.split('').map((c) {
      if (c == ' ') return ' ';
      return '_';
    }).toList();
    typedAnswer = "";
  }

  Widget tebakKataHewanPage() {
    final rows = [
      "ABCDEF".split(''),
      "GHIJKL".split(''),
      "MNOPQR".split(''),
      "STUVWX".split(''),
      "YZ".split(''),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Tebak Kata (Hewan)",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Lihat gambarnya, lalu ketik nama hewan yang benar.",
              style: TextStyle(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Image.asset("assets/images/$currentImage",
                    width: 140, height: 140, fit: BoxFit.cover),
                const SizedBox(height: 8),
                Text(
                  masked.join(' '),
                  style: const TextStyle(
                      fontSize: 28,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    typedAnswer.isEmpty ? "_" : typedAnswer,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    startTebakKataHewan();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                child: const Text("Acak Lagi"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < masked.length; i++) {
                      if (masked[i] == '_') {
                        masked[i] = currentWord[i];
                        break;
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                child: const Text("Hint"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (var row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: row.map((e) => keyboardButton(e)).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    keyboardButton("SPASI"),
                    const SizedBox(width: 8),
                    keyboardButton("DELETE"),
                    const SizedBox(width: 8),
                    keyboardButton("ENTER"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitTebakKataHewan() {
    final guess = typedAnswer.trim().toUpperCase();
    if (guess.isEmpty) {
      showResultDialog("Ketik jawaban terlebih dulu!");
      return;
    }

    if (guess == currentWord) {
      setState(() {
        for (int i = 0; i < masked.length; i++) masked[i] = currentWord[i];
      });
      showResultDialog("Benar! Kata: $currentWord");
    } else {
      showResultDialog("Salah. Jawaban benar: $currentWord");
    }

    typedAnswer = "";
  }

  void showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hasil"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                startTebakKataHewan();
              });
            },
            child: const Text("Oke"),
          )
        ],
      ),
    );
  }

}
