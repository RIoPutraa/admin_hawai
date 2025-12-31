import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  // ganti sesuai URL backend kamu

  // Ambil semua pendaftar
  static Future<List<Map<String, dynamic>>> getAllPendaftar() async {
    final res = await http.get(Uri.parse("$baseUrl/users"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return [];
  }

  // Tambah user manual
  static Future<bool> createUser(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  // Update user
  static Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/users/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 200;
  }

  // Hapus user
  static Future<bool> deleteUser(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/users/$id"));
    return res.statusCode == 200;
  }

  // Terima pendaftar → misalnya update status
  static Future<bool> acceptUser(String id) async {
    final res = await http.post(Uri.parse("$baseUrl/users/$id/accept"));
    return res.statusCode == 200;
  }

  // Upload Excel
  static Future<bool> importExcel(String filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/users/import"),
    );
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final res = await request.send();
    return res.statusCode == 200;
  }

  // Download template Excel
  static Future<http.Response> downloadTemplate() async {
    return await http.get(Uri.parse("$baseUrl/users/template"));
  }
}
