import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class SpeechToSignLanguagePage extends StatefulWidget {
  const SpeechToSignLanguagePage({super.key});

  @override
  State<SpeechToSignLanguagePage> createState() => _SpeechToSignLanguagePageState();
}

class _SpeechToSignLanguagePageState extends State<SpeechToSignLanguagePage> {
  bool _available = false;
  bool _listening = false;
  List<String> _signLanguageImages = [];
  Duration _recordDuration = Duration.zero;
  DateTime? _startTime;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  String? _lastRecordingPath;
  Timer? _timer;

  bool get _recordSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _init() async {
    if (_available) return;

    if (_recordSupported) {
      try {
        _available = await _recorder.hasPermission();
      } catch (e) {
        _available = false;
      }
    }

    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_available && !_recordSupported) {
      await _init();
    }

    if (!_recordSupported) {
      _showSnack('Perekaman tidak didukung pada platform ini');
      return;
    }

    final bool hasPerm = kIsWeb ? true : await _recorder.hasPermission();
    if (!hasPerm) {
      _showSnack('Izin mikrofon diperlukan');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
        path: filePath,
      );

      _lastRecordingPath = filePath;
    } catch (e) {
      _showSnack('Gagal memulai perekaman: $e');
      return;
    }

    setState(() {
      _listening = true;
      _signLanguageImages = [];
      _recordDuration = Duration.zero;
      _startTime = DateTime.now();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_listening) {
        timer.cancel();
        return;
      }
      setState(() {
        _recordDuration = DateTime.now().difference(_startTime!);
      });
    });
  }

  Future<void> _stopListening() async {
    _timer?.cancel();

    if (_recordSupported) {
      try {
        final isRecording = await _recorder.isRecording();
        if (isRecording) {
          final path = await _recorder.stop();
          if (path != null) _lastRecordingPath = path;
        }
      } catch (e) {
        _showSnack('Gagal menghentikan perekaman: $e');
        return;
      }
    }

    setState(() {
      _listening = false;
      if (_startTime != null) {
        _recordDuration = DateTime.now().difference(_startTime!);
      }
    });
  }

  Future<void> _translateAudioToSign() async {
    if (_lastRecordingPath == null) {
      _showSnack('Silakan rekam suara terlebih dahulu.');
      return;
    }

    setState(() {});
    _showSnack('Menerjemahkan audio...');

    await Future.delayed(const Duration(seconds: 2));
    String recognizedText = 'Halo, saya ingin belajar bahasa isyarat';

    _showSnack('Teks dikenali: "$recognizedText"');

    await Future.delayed(const Duration(seconds: 1));

    List<String> signImages = [
      'https://via.placeholder.com/80x80/0000FF/FFFFFF?text=H',
      'https://via.placeholder.com/80x80/0000FF/FFFFFF?text=A',
      'https://via.placeholder.com/80x80/0000FF/FFFFFF?text=L',
      'https://via.placeholder.com/80x80/0000FF/FFFFFF?text=O'
    ];

    setState(() {
      _signLanguageImages = signImages;
      _showSnack('Terjemahan selesai!');
    });
  }

  Widget _buildMicButton() {
    bool disabled = !_recordSupported || !_available;

    return GestureDetector(
      onTap: disabled
          ? () => _showSnack('Mikrofon tidak siap atau izin diperlukan.')
          : () async {
              if (_listening) {
                await _stopListening();
              } else {
                await _startListening();
              }
            },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade400 : const Color(0xFF5AB8C1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _listening ? Icons.mic : Icons.mic_none,
          size: 60,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildStatusText() {
    if (!_recordSupported) {
      return const Text('Perekaman tidak didukung.', style: TextStyle(color: Colors.red));
    }

    if (!_available && !kIsWeb) {
      return const Text('Izin mikrofon diperlukan.', style: TextStyle(color: Colors.red));
    }

    return Text(
      _listening ? 'Sedang merekam...\nketuk lagi untuk berhenti'
          : 'Ketuk untuk mulai berbicara',
      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayback() {
    if (!_recordSupported || _lastRecordingPath == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;

        return IconButton(
          icon: Icon(
            playing ? Icons.stop_circle : Icons.play_circle_fill,
            size: 36,
          ),
          onPressed: () async {
            try {
              if (playing) {
                await _player.stop();
              } else {
                await _player.setFilePath(_lastRecordingPath!);
                await _player.play();
              }
            } catch (e) {
              _showSnack('Gagal memutar audio');
            }
          },
        );
      },
    );
  }

  Widget _buildTranscriptionActions() {
    if (!_recordSupported || _lastRecordingPath == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF5AB8C1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: _listening ? null : _translateAudioToSign,
          child: const Text('Terjemahkan', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () async {
            await _player.stop();
            setState(() {
              _signLanguageImages = [];
              _lastRecordingPath = null;
              _recordDuration = Duration.zero;
              _startTime = null;
            });
          },
          child: const Text('Batal', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildSignLanguageDisplay() {
    if (_signLanguageImages.isEmpty) {
      return const SizedBox(height: 100);
    }

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _signLanguageImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                _signLanguageImages[index],
                width: 80,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 100,
                    color: Colors.red.shade100,
                    child: const Center(child: Text('Gagal', style: TextStyle(fontSize: 10))),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration d) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B83A7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Speech To Sign Language',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSignLanguageDisplay(),

            Container(
              width: 280,
              height: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMicButton(),
                  const SizedBox(height: 20),
                  _buildStatusText(),
                  const SizedBox(height: 12),

                  if (_recordDuration > Duration.zero)
                    Text(
                      'Durasi: ${formatDuration(_recordDuration)}',
                      style: const TextStyle(color: Colors.black54),
                    ),

                  const SizedBox(height: 12),
                  _buildPlayback(),
                  const SizedBox(height: 10),
                  _buildTranscriptionActions(),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => GestureToTextPage(),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Mode Gesture (Kamera)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
