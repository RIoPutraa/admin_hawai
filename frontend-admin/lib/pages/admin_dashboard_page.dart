import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_tes/constants/colors.dart';
import 'package:login_tes/widgets/admin_sidebar.dart';
import 'package:login_tes/widgets/stat_card.dart';
import 'admin_pendaftaran_page.dart';
import 'admin_pengaduan_page.dart';
import 'admin_pengajuan_surat_page.dart';

class AdminDashboardPage extends StatefulWidget {
  final Map<String, dynamic> adminData;
  final String token;

  const AdminDashboardPage({
    super.key,
    required this.adminData,
    required this.token,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  String _currentPage = 'dashboard';

  int totalSurat = 0; // ganti dari totalPendaftaran
  int totalPengaduan = 0;
  int totalUser = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatistik();
  }

  Future<void> _fetchStatistik() async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/admin/statistik');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalSurat = data['surat']; // ambil dari key 'surat'
          totalPengaduan = data['pengaduan'];
          totalUser = data['user'];
        });
      } else {
        print('Gagal ambil statistik: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentPage = 'dashboard';
          break;
        case 1:
          _currentPage = 'pendaftaran';
          break;
        case 2:
          _currentPage = 'pengaduan';
          break;
        case 3:
          _currentPage = 'pengajuan_surat';
          break;
      }
    });
  }

  Widget _buildContent() {
    switch (_currentPage) {
      case 'dashboard':
        return _buildDashboardContent();
      case 'pendaftaran':
        return AdminUserPage(token: widget.token);
      case 'pengaduan':
        return AdminPengaduanPage(token: widget.token);
      case 'pengajuan_surat':
        return AdminPengajuanSuratPage(token: widget.token);
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final statCards = [
                StatCard(
                  title: 'Total Surat', // ganti label
                  value: totalSurat.toString(),
                  icon: Icons.mail, // icon surat
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'Total Pengaduan',
                  value: totalPengaduan.toString(),
                  icon: Icons.report_problem,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Total User',
                  value: totalUser.toString(),
                  icon: Icons.people,
                  color: Colors.green,
                ),
              ];

              if (constraints.maxWidth < 600) {
                return Column(
                  children: statCards
                      .map(
                        (card) => Padding(
                          padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                          child: card,
                        ),
                      )
                      .toList(),
                );
              } else {
                return Row(
                  children: statCards
                      .map(
                        (card) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isMobile ? 12 : 16),
                            child: card,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final nama = widget.adminData['name'] ?? 'Admin'; // ambil nama dari users

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              backgroundColor: primaryColor,
              title: const Text(
                'Dashboard Admin',
                style: TextStyle(color: whiteColor),
              ),
              iconTheme: const IconThemeData(color: whiteColor),
            )
          : null,
      drawer: isMobile
          ? Drawer(
              width: 250,
              child: AdminSidebar(
                nama: nama,
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
                onLogout: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            AdminSidebar(
              nama: nama,
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              alignment: Alignment.topLeft,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
