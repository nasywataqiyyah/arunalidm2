import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SttService {
  final String apiKey = "494eb8f1ceea451a886bc3e1c03a563b";

  // ===========================================================
  // 1. UPLOAD AUDIO (WAV) - 100% WORKING
  // ===========================================================
  Future<String?> uploadAudio(String filePath) async {
    final url = Uri.parse("https://api.assemblyai.com/v2/upload");

    final file = File(filePath);
    if (!await file.exists()) {
      print("UPLOAD ERROR: FILE NOT FOUND");
      return null;
    }

    final bytes = await file.readAsBytes();
    final chunkSize = 5 * 1024 * 1024; // 5MB

    int start = 0;
    String? uploadedUrl;

    print("=== START UPLOAD AUDIO ===");
    print("FILE SIZE: ${bytes.length} bytes");

    while (start < bytes.length) {
      final end =
      (start + chunkSize > bytes.length) ? bytes.length : start + chunkSize;

      final chunk = bytes.sublist(start, end);

      final response = await http.post(
        url,
        headers: {
          "Authorization": apiKey,
          "Content-Type": "application/octet-stream",
        },
        body: chunk,
      );

      print("UPLOAD STATUS: ${response.statusCode}");
      print("UPLOAD RESP: ${response.body}");

      if (response.statusCode != 200) {
        print("UPLOAD FAILED");
        return null;
      }

      uploadedUrl = jsonDecode(response.body)["upload_url"];
      start = end;
    }

    return uploadedUrl;
  }

  // ===========================================================
  // 2. REQUEST TRANSCRIPTION
  // ===========================================================
  Future<String?> requestTranscription(String uploadUrl) async {
    final url = Uri.parse("https://api.assemblyai.com/v2/transcript");

    final response = await http.post(
      url,
      headers: {
        "Authorization": apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "audio_url": uploadUrl,
        "language_code": "id",
        "punctuate": true,
      }),
    );

    print("REQUEST TRANSCRIBE: ${response.statusCode}");
    print("REQUEST RESP: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["id"];
    }

    return null;
  }

  // ===========================================================
  // 3. CEK STATUS SAMPAI SELESAI
  // ===========================================================
  Future<String> checkStatus(String id) async {
    final url = Uri.parse("https://api.assemblyai.com/v2/transcript/$id");

    while (true) {
      final res = await http.get(url, headers: {
        "Authorization": apiKey,
      });

      print("STATUS RAW: ${res.body}");

      final json = jsonDecode(res.body);
      final status = json["status"];

      print("STATUS PARSED: $status");

      if (status == "completed") {
        return json["text"] ?? "";
      }

      if (status == "error") {
        return "Error: ${json["error"]}";
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  // ===========================================================
  // 4. TRANSCIBE AUDIO (FULL PROCESS)
  // ===========================================================
  Future<String> transcribeAudio(String filePath) async {
    print("=== MULAI UPLOAD ===");

    final uploadUrl = await uploadAudio(filePath);
    if (uploadUrl == null) return "Upload audio gagal";

    print("=== MINTA TRANSKRIPSI ===");

    final id = await requestTranscription(uploadUrl);
    if (id == null) return "Gagal request transkripsi";

    print("=== CEK STATUS ===");

    return await checkStatus(id);
  }
}
