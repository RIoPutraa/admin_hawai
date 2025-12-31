import 'package:flutter/material.dart';
import 'package:login_tes/constants/colors.dart';

class DetailSuratDialog extends StatelessWidget {
  final Map<String, dynamic> surat;
  const DetailSuratDialog({super.key, required this.surat});

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
    final statusColor = _getStatusColor(surat['status'] ?? '');

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pengajuan Surat",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildDetailRow("Nama", surat['name']),
              _buildDetailRow("Jenis Surat", surat['jenisSurat']),
              _buildDetailRow("Keperluan", surat['keperluan']),
              _buildDetailRow("Tanggal", surat['tanggal']),
              _buildDetailRow("Catatan RT", surat['catatanRt']),

              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      surat['status'] ?? '-',
                      style: const TextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: primaryColor),
                  label: const Text(
                    "Tutup",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value?.toString() ?? "-")),
        ],
      ),
    );
  }
}
