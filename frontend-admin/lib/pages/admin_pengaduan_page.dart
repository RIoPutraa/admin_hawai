import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_tes/constants/colors.dart';

class AdminPengaduanPage extends StatefulWidget {
  final String token;
  const AdminPengaduanPage({super.key, required this.token});

  @override
  State<AdminPengaduanPage> createState() => _AdminPengaduanPageState();
}

class _AdminPengaduanPageState extends State<AdminPengaduanPage> {
  List<dynamic> pengaduanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPengaduan();
  }

  Future<void> _fetchPengaduan() async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/admin/pengaduan');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          pengaduanList = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Gagal ambil pengaduan: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.grey;
      case 'approved':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      case 'done':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: const TextStyle(color: whiteColor, fontSize: 11),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaduan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'User',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Judul',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Lokasi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Feedback',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Tanggal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...pengaduanList.map(
                        (p) => _buildTableRow(
                          p['id']?.toString() ?? '-',
                          // ambil nama user dari API join
                          p['user_name']?.toString() ?? '-',
                          p['title']?.toString() ?? '-',
                          p['location']?.toString() ?? '-',
                          p['description']?.toString() ?? '-',
                          p['status']?.toString() ?? '-',
                          p['feedback']?.toString() ?? '-',
                          p['created_at']?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    String id,
    String userName,
    String title,
    String location,
    String description,
    String status,
    String feedback,
    String tanggal,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(id, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(userName, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(location, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(flex: 2, child: _buildStatusBadge(status)),
          Expanded(
            flex: 3,
            child: Text(feedback, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(tanggal, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
