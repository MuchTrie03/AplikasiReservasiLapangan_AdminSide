import 'package:flutter/material.dart';
import 'detail_pelanggan.dart'; // Import file detail_pelanggan.dart

class DataPelangganPage extends StatelessWidget {
  const DataPelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jarak dari atas layar
              const SizedBox(height: 40),
              // Row untuk tombol back dan judul
              Row(
                children: [
                  // Tombol back
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                  ),
                  const SizedBox(width: 10), // Jarak antara tombol dan judul
                  // Judul
                  const Text(
                    'Data Pelanggan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Jarak antara judul dan konten
              // List data pelanggan
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Contoh: 10 pelanggan
                  itemBuilder: (context, index) {
                    return _buildPelangganItem(
                      context,
                      'Pelanggan ${index + 1}',
                      'email${index + 1}@example.com',
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat item pelanggan
  Widget _buildPelangganItem(
    BuildContext context,
    String nama,
    String email,
    int index,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          nama,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onTap: () {
          // Navigasi ke halaman detail pelanggan dengan data dummy
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPelangganPage(
                nama: nama,
                email: email,
                noTelepon: '08123456789${index + 1}', // Nomor telepon dummy
              ),
            ),
          );
        },
      ),
    );
  }
}
