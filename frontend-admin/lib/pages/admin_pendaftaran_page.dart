import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:login_tes/constants/colors.dart';
import 'admin_add_user_page.dart';
import 'admin_import_user_page.dart';

class AdminUserPage extends StatefulWidget {
  final String token;
  const AdminUserPage({super.key, required this.token});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  List<dynamic> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/admin/users');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userList = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.blue;
      case 'rt':
        return Colors.green;
      case 'rw':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _roleColor(role),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: const TextStyle(color: whiteColor, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _downloadTemplate() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/admin/users/template');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminAddUserPage(token: widget.token),
                        ),
                      ).then((_) => _fetchUsers());
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Tambah User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _downloadTemplate,
                    icon: const Icon(Icons.download),
                    label: const Text('Download Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdminImportUserPage(token: widget.token),
                        ),
                      ).then((_) => _fetchUsers());
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Import Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Table
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userList.isEmpty
              ? const Text(
                  'Tidak ada data user',
                  style: TextStyle(color: greyColor),
                )
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
                                'No',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'NIK',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Nama',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Telp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Role',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...userList.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final u = entry.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  index.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  u['nik']?.toString() ?? '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  u['name']?.toString() ?? '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  u['userID']?.toString() ?? '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  u['phone']?.toString() ?? '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildRoleBadge(
                                  u['role']?.toString() ?? '-',
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
