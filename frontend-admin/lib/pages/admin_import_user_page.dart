import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:login_tes/constants/colors.dart';

class AdminImportUserPage extends StatefulWidget {
  final String token;
  const AdminImportUserPage({super.key, required this.token});

  @override
  State<AdminImportUserPage> createState() => _AdminImportUserPageState();
}

class _AdminImportUserPageState extends State<AdminImportUserPage> {
  PlatformFile? _pickedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
      withData: true, // penting untuk web supaya ada bytes
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.single;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File dipilih: ${_pickedFile!.name}'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada file dipilih'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _uploadFile() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih file dulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/admin/users/import'),
    );
    request.headers['Authorization'] = 'Bearer ${widget.token}';

    if (kIsWeb) {
      // Web: gunakan bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _pickedFile!.bytes!,
          filename: _pickedFile!.name,
        ),
      );
    } else {
      // Mobile/Desktop: gunakan path
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _pickedFile!.path!,
          filename: _pickedFile!.name,
        ),
      );
    }

    final response = await request.send();
    setState(() => _isUploading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import berhasil'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unauthorized: Token tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import gagal (${response.statusCode})'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import User Excel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Pilih File'),
            ),
            const SizedBox(height: 20),
            if (_pickedFile != null) Text('File: ${_pickedFile!.name}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadFile,
              icon: _isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: whiteColor,
                      ),
                    )
                  : const Icon(Icons.upload),
              label: Text(_isUploading ? 'Uploading...' : 'Upload'),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
