import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_tes/constants/colors.dart';

class AdminAddUserPage extends StatefulWidget {
  final String token;
  const AdminAddUserPage({super.key, required this.token});

  @override
  State<AdminAddUserPage> createState() => _AdminAddUserPageState();
}

class _AdminAddUserPageState extends State<AdminAddUserPage> {
  final _formKey = GlobalKey<FormState>();
  String nik = '';
  String name = '';
  String password = '';
  String gender = 'Laki-laki';
  String phone = '';
  String role = 'rt';
  String address = '';

  Future<void> _submitUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse('http://127.0.0.1:8000/api/admin/users');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
        body: {
          'nik': nik,
          'name': name,
          'password': password,
          'gender': gender,
          'phone': phone,
          'role': role,
          'address': address,
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan user (${response.statusCode})'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'NIK'),
                validator: (val) => val!.isEmpty ? 'NIK wajib diisi' : null,
                onSaved: (val) => nik = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (val) => val!.isEmpty ? 'Nama wajib diisi' : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Minimal 6 karakter' : null,
                onSaved: (val) => password = val!,
              ),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (val) => setState(() => gender = val!),
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'No. Telp'),
                onSaved: (val) => phone = val ?? '',
              ),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'rt', child: Text('RT')),
                  DropdownMenuItem(value: 'rw', child: Text('RW')),
                ],
                onChanged: (val) => setState(() => role = val!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat'),
                onSaved: (val) => address = val ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitUser,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
