import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_tes/constants/colors.dart';
import 'package:login_tes/widgets/detail_surat_dialog.dart';

class AdminPengajuanSuratPage extends StatefulWidget {
  final String token;
  const AdminPengajuanSuratPage({super.key, required this.token});

  @override
  State<AdminPengajuanSuratPage> createState() =>
      _AdminPengajuanSuratPageState();
}

class _AdminPengajuanSuratPageState extends State<AdminPengajuanSuratPage> {
  List<dynamic> _pengajuan = [];
  bool _loading = true;

  Future<void> _fetchPengajuan() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/admin/pengajuan-surat'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _pengajuan = jsonDecode(response.body)['data'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal load data (${response.statusCode})')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPengajuan();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'disetujui':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengajuan Surat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
              child: _loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.grey.shade100,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Nama',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    'Jenis Surat',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Keperluan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Catatan RT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Opsi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Content dari API
                          for (var item in _pengajuan)
                            _buildTableRow(
                              item['name'] ?? '-', // nama dari tabel users
                              item['id_jenis_surat'].toString(),
                              item['keperluan'] ?? '-',
                              item['tanggal_pengajuan'] ?? '-',
                              item['status'] ?? '-',
                              item['catatan_rt'] ?? '-',
                              context,
                              isMobile,
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String nama,
    String jenisSurat,
    String keperluan,
    String tanggal,
    String status,
    String catatanRt,
    BuildContext context,
    bool isMobile,
  ) {
    final statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(nama, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 150,
            child: Text(jenisSurat, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 200,
            child: Text(
              keperluan,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(tanggal, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: const TextStyle(color: whiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              catatanRt,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DetailSuratDialog(
                    surat: {
                      'name': nama,
                      'jenisSurat': jenisSurat,
                      'keperluan': keperluan,
                      'tanggal': tanggal,
                      'status': status,
                      'catatanRt': catatanRt,
                    },
                  ),
                );
              },
              child: const Text(
                'Detail',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
