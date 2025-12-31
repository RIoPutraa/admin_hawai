import 'package:flutter/material.dart';
import 'package:login_tes/constants/colors.dart';
import 'package:login_tes/pages/login_page.dart';

class AdminSidebar extends StatelessWidget {
  final String nama;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onLogout;

  const AdminSidebar({
    super.key,
    required this.nama,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/images/avatar.jpg'),
              backgroundColor: whiteColor,
            ),
            const SizedBox(height: 12),
            Text(
              nama,
              style: const TextStyle(
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Menu utama
            _buildMenuItem(context, 0, Icons.dashboard, 'Dashboard'),
            _buildMenuItem(context, 1, Icons.person_add, 'Pendaftaran'),
            _buildMenuItem(context, 2, Icons.report_problem, 'Pengaduan'),
            _buildMenuItem(context, 3, Icons.description, 'Pengajuan Surat'),

            const Spacer(),
            InkWell(
              onTap: onLogout,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: whiteColor, size: 20),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: whiteColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    int index,
    IconData icon,
    String title,
  ) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? whiteColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: whiteColor, size: 20),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: whiteColor)),
          ],
        ),
      ),
    );
  }
}
