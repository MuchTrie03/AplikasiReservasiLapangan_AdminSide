import 'package:flutter/material.dart';
import '../models/Reservation.dart';

class DetailJadwal extends StatefulWidget {
  final Reservation reservation; // Parameter reservation

  const DetailJadwal({super.key, required this.reservation}); // Konstruktor

  @override
  _DetailJadwalState createState() => _DetailJadwalState();
}

class _DetailJadwalState extends State<DetailJadwal> {
  // Fungsi untuk memformat waktu ke format 00:00
  String _formatTime(String time) {
    // Jika waktu sudah dalam format 00:00, langsung kembalikan
    if (time.length == 5 && time.contains(':')) {
      return time;
    }

    // Jika waktu dalam format "HH:mm" (tanpa leading zero), tambahkan leading zero
    final parts = time.split(':');
    if (parts.length == 2) {
      final hour =
          parts[0].padLeft(2, '0'); // Tambahkan leading zero jika perlu
      final minute =
          parts[1].padLeft(2, '0'); // Tambahkan leading zero jika perlu
      return '$hour:$minute';
    }

    // Jika format tidak valid, kembalikan waktu asli
    return time;
  }

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
              const SizedBox(height: 40),
              Row(
                children: [
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
                  const SizedBox(width: 10),
                  Text(
                    'Detail Jadwal ${widget.reservation.field}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildJadwalItem(
                widget.reservation.date,
                _formatTime(widget.reservation.time), // Format waktu ke 00:00
                'Dipakai',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat item jadwal
  Widget _buildJadwalItem(String tanggal, String waktu, String status) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          'Tanggal: $tanggal',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waktu: $waktu', // Waktu sudah diformat ke 00:00
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            Text(
              'Status: $status',
              style: TextStyle(
                fontSize: 14,
                color: status == 'Tersedia' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
