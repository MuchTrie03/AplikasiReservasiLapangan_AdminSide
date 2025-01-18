import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan import ke login.dart sudah benar
//import 'dashboard_screen.dart'; // hapus dan ganti ke halaman login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;
  int _dotCount = 0; // Untuk animasi titik-titik

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animasi fade in
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeIn,
    );

    // Animasi scale (pop-up)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.elasticOut, // Efek pop-up dengan elasticOut
      ),
    );

    // Mulai animasi
    _animationController!.forward();

    // Animasi titik-titik
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // Animasi titik-titik (0 hingga 3)
      });
    });

    // Navigasi ke halaman berikutnya setelah 8 detik
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(), // Ganti ke halaman yang dituju
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 18, 19),
              Color.fromARGB(255, 161, 13, 13)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: ScaleTransition(
              scale: _scaleAnimation!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo tanpa latar belakang putih
                  Image.asset(
                    'assets/img/logo2.png',
                    width: 400, // Perbesar ukuran logo
                    height: 400, // Perbesar ukuran logo
                    fit:
                        BoxFit.contain, // Pastikan logo sesuai dengan container
                  ),
                  const SizedBox(
                      height: 20), // Jarak antara logo dan titik-titik

                  // Animasi titik-titik (tanpa tulisan "Loading")
                  Text(
                    '.' * _dotCount, // Animasi titik-titik
                    style: const TextStyle(
                      fontSize: 40, // Perbesar ukuran titik-titik
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
