import 'package:flutter/material.dart';
import 'package:login_tes/constants/colors.dart';

class TambahPendaftarDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? pendaftar; // Untuk edit mode

  const TambahPendaftarDialog({
    super.key,
    required this.onSubmit,
    this.pendaftar,
  });

  @override
  State<TambahPendaftarDialog> createState() => _TambahPendaftarDialogState();
}

class _TambahPendaftarDialogState extends State<TambahPendaftarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _telpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika edit mode, isi form dengan data yang ada
    if (widget.pendaftar != null) {
      _nikController.text = widget.pendaftar!['nik'] ?? '';
      _namaController.text = widget.pendaftar!['nama'] ?? '';
      _telpController.text = widget.pendaftar!['telp'] ?? '';
      _passwordController.text = widget.pendaftar!['password'] ?? '';
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _telpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'nik': _nikController.text.trim(),
        'nama': _namaController.text.trim(),
        'telp': _telpController.text.trim(),
        'password': _passwordController.text.trim(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pendaftar != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Pendaftar' : 'Tambah Pendaftar',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nikController,
                  decoration: InputDecoration(
                    labelText: 'NIK',
                    hintText: 'Masukkan NIK',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK tidak boleh kosong';
                    }
                    if (value.length < 16) {
                      return 'NIK harus 16 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Masukkan nama lengkap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telpController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukkan nomor telepon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: greyColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Simpan' : 'Tambah',
                        style: const TextStyle(color: whiteColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


