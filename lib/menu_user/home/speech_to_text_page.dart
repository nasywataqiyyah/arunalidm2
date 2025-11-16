import 'package:arunaapp/menu_user/services/stt_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  bool _available = false;
  bool _listening = false;
  String _transcribedText = '';
  Duration _recordDuration = Duration.zero;
  DateTime? _startTime;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  String? _lastRecordingPath;

  bool get _recordSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
    await _init();
    if (!_recordSupported) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording not supported on this platform'),
          ),
        );
      }
      return;
    }
    // On web, record plugin is not used but we still allow the flow.
    final bool hasPerm = kIsWeb ? true : await _recorder.hasPermission();
    if (!hasPerm) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required')),
        );
      }
      return;
    }
    if (kIsWeb) {
      try {
        await _recorder.start(
          // Use WAV on web for broad compatibility and reliable data chunks
          const RecordConfig(encoder: AudioEncoder.wav, bitRate: 128000),
          path: '',
        );
        _lastRecordingPath = null;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to start recording: $e')),
          );
        }
        return;
      }
    } else {
      try {
        final dir = await getTemporaryDirectory();
        final String filePath =
            '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
          path: filePath,
        );
        _lastRecordingPath = filePath;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to start recording: $e')),
          );
        }
        return;
      }
    }
    setState(() {
      _listening = true;
      _transcribedText = '';
      _recordDuration = Duration.zero;
      _startTime = DateTime.now();
    });
  }

  Future<void> _stopListening() async {
    // stop audio recording
    if (_recordSupported) {
      try {
        // Ensure we only stop if a recording session is active
        final isRecording = await _recorder.isRecording();
        if (isRecording) {
          // On web, MediaRecorder emits data every ~200ms; stopping too quickly can yield no data (null path)
          if (kIsWeb && _startTime != null) {
            final elapsed = DateTime.now().difference(_startTime!);
            const minElapsed = Duration(milliseconds: 300);
            if (elapsed < minElapsed) {
              await Future.delayed(minElapsed - elapsed);
            }
          }
        }

        final path = isRecording ? await _recorder.stop() : null;
        if (path != null) {
          _lastRecordingPath = path;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to stop recording: $e')),
          );
        }
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

  @override
  void dispose() {
    // Ensure resources are released
    _player.dispose();
    super.dispose();
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: () async {
        if (_listening) {
          await _stopListening();
        } else {
          await _startListening();
        }
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: const BoxDecoration(
          color: Color(0xFF5AB8C1),
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
    return Text(
      _listening
          ? 'Sedang merekam...\nketuk lagi untuk berhenti'
          : 'Ketuk untuk mulai berbicara',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
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
        final processingState = playerState?.processingState;
        final playing = playerState?.playing ?? false;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        if (processingState == ProcessingState.completed) {
          return IconButton(
            icon: const Icon(
              Icons.play_circle_fill,
              color: Colors.black87,
              size: 36,
            ),
            onPressed: () async {
              try {
                // Re-prepare source to ensure playback restarts reliably across platforms
                if (kIsWeb) {
                  await _player.setUrl(_lastRecordingPath!);
                } else {
                  await _player.setFilePath(_lastRecordingPath!);
                }
                await _player.seek(Duration.zero);
                await _player.play();
              } catch (e) {
                _showSnack('Gagal memutar audio');
              }
            },
          );
        }

        return IconButton(
          icon: Icon(
            playing ? Icons.stop_circle : Icons.play_circle_fill,
            color: Colors.black87,
            size: 36,
          ),
          onPressed: () async {
            try {
              if (playing) {
                await _player.stop();
              } else {
                if (kIsWeb) {
                  await _player.setUrl(_lastRecordingPath!);
                } else {
                  await _player.setFilePath(_lastRecordingPath!);
                }
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
          onPressed: _listening
              ? null
              : () async {
                  setState(() => _transcribedText = 'Transcribing...');
                  final result = await SttService().transcribeAudio(
                    _lastRecordingPath!,
                  );
                  if (!mounted) return;
                  setState(() => _transcribedText = result);
                },
          child: const Text(
            'Terjemahkan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () async {
            try {
              await _player.stop();
              _lastRecordingPath = null;
              _recordDuration = Duration.zero;
              _startTime = null;
            } catch (_) {}
            setState(() {
              _transcribedText = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B83A7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B83A7),
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Speech To Text',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 360,
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
                      'Durasi: ${_recordDuration.inSeconds}s',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  const SizedBox(height: 12),
                  if (_transcribedText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _transcribedText,
                        style: const TextStyle(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 8),
                  _buildPlayback(),
                  const SizedBox(height: 6),
                  _buildTranscriptionActions(),
                ],
              ),
            ),
          ],
        ),
      ),
      // no bottom nav here; follows edit profile style using default AppBar back
    );
  }
}
