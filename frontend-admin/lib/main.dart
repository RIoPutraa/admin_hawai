import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hawaii Garden',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF164E47)),
        useMaterial3: true,
      ),

      // Halaman pertama saat app dibuka
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        // AdminDashboardPage butuh parameter adminData & token dari login,
        // jadi jangan dipanggil langsung lewat routes statis.
        // Navigasi ke dashboard dilakukan di login_page.dart setelah login sukses.
      },
    );
  }
}
