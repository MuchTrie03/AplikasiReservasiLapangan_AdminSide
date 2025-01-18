import 'package:flutter/material.dart';

class DetailPelangganPage extends StatelessWidget {
  final String nama;
  final String email;
  final String noTelepon;

  const DetailPelangganPage({
    super.key,
    required this.nama,
    required this.email,
    required this.noTelepon,
  });

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk riwayat reservasi lapangan futsal
    final List<Map<String, String>> riwayatReservasi = [
      {
        'tanggal': '2023-10-01',
        'lapangan': 'Lapangan A',
        'waktu': '18:00 - 20:00',
        'status': 'Selesai',
      },
      {
        'tanggal': '2023-09-25',
        'lapangan': 'Lapangan B',
        'waktu': '20:00 - 22:00',
        'status': 'Selesai',
      },
      {
        'tanggal': '2023-09-20',
        'lapangan': 'Lapangan A',
        'waktu': '16:00 - 18:00',
        'status': 'Dibatalkan',
      },
    ];

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
                  Text(
                    'Detail Pelanggan',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Jarak antara judul dan konten

              // Card Informasi Pelanggan
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Foto Profil
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/img/user.jpg'), // Ganti dengan path foto profil
                      ),
                      const SizedBox(width: 16),
                      // Informasi Pelanggan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noTelepon,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Riwayat Reservasi Lapangan Futsal
              const Text(
                'Riwayat Reservasi',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 0),
              Expanded(
                child: ListView.builder(
                  itemCount: riwayatReservasi.length,
                  itemBuilder: (context, index) {
                    final reservasi = riwayatReservasi[index];
                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          'Lapangan: ${reservasi['lapangan']!}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Tanggal: ${reservasi['tanggal']!}\nWaktu: ${reservasi['waktu']!}\nStatus: ${reservasi['status']!}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
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
}
