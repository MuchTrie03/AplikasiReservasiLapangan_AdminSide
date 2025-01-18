import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Pastikan import ke dashboard_screen.dart sudah benar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passToggle = true; // Untuk toggle visibility password

  // Dummy credentials for login simulation
  final String correctEmail = "much@gmail.com";
  final String correctPassword = "123456";

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memastikan konten mengisi seluruh layar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Menghilangkan shadow
      ),
      body: Container(
        width: double.infinity, // Mengisi lebar layar
        height: double.infinity, // Mengisi tinggi layar
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Pusatkan vertikal
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Pusatkan horizontal
                  children: [
                    // Gambar avatar/logo
                    Image.asset(
                      "assets/img/logo2.png", // Pastikan path sudah benar
                      height: 400, // Ukuran logo diperbesar
                    ),
                    const SizedBox(height: 10),

                    // Input email
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.email,
                              color: Color.fromARGB(179, 243, 243, 243)),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // Warna teks validasi
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan email';
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Masukan email yang valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Input password
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passController,
                        obscureText:
                            passToggle, // Mengontrol visibility password
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white70),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle; // Toggle visibility
                              });
                            },
                            child: Icon(
                              passToggle
                                  ? Icons
                                      .visibility_off // Saat password disembunyikan
                                  : Icons
                                      .visibility, // Saat password ditampilkan
                              color: Colors.white70,
                            ),
                          ),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // Warna teks validasi
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'tolong masukan password';
                          } else if (value.length < 6) {
                            return 'Password harus memiliki 6 karakter';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol login
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text == correctEmail &&
                                passController.text == correctPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Login Successful")),
                              );
                              emailController.clear();
                              passController.clear();

                              // Navigasi ke Dashboard setelah login berhasil
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Akun tidak ditemukan")),
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 161, 13, 13),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Link untuk sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: TextStyle(fontSize: 17, color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            // Tambahkan navigasi ke halaman pendaftaran jika ada
                          },
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
