import 'package:flutter/material.dart';
import 'detail_jadwal.dart'; // Import file detail_jadwal.dart
import 'package:url_launcher/url_launcher.dart';
import '../models/DatabaseHelper.dart';
import '../models/Reservation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Indeks item yang dipilih di Bottom Navigation Bar

  // Daftar halaman yang akan ditampilkan di Bottom Navigation Bar
  final List<Widget> _pages = const [
    HomePage(), // Halaman Dashboard
    ReservationPage(), // Halaman Reservasi
    AboutPage(), // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Perbarui indeks yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memastikan konten mengisi seluruh layar
      appBar: null, // Hilangkan AppBar
      body: _pages[_selectedIndex], // Tampilkan halaman yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indeks item yang aktif
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item diklik
        backgroundColor:
            const Color.fromARGB(255, 17, 18, 19), // Warna latar belakang
        selectedItemColor: Colors.white, // Warna item yang dipilih
        unselectedItemColor: Colors.white70, // Warna item yang tidak dipilih
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reservasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

// Halaman Dashboard
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Reservation>> futureReservationsToday;

  @override
  void initState() {
    super.initState();
    futureReservationsToday = _getReservationsToday();
  }

  Future<List<Reservation>> _getReservationsToday() async {
    final dbHelper = DatabaseHelper();
    final today = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD
    return await dbHelper.getReservationsByDate(today);
  }

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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Pastikan tinggi sesuai dengan layar
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jarak dari atas layar
                  const SizedBox(height: 40),
                  // Header
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Selamat Datang, Admin!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Statistik Cepat
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.calendar_today,
                              title: 'Reservasi Hari Ini',
                              value: '2',
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.sports_soccer,
                              title: 'Lapangan Tersedia',
                              value: '2',
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Grafik Reservasi Bulanan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grafik Reservasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Dropdown untuk memilih filter grafik
                      DropdownButton<String>(
                        value: 'Harian',
                        dropdownColor: const Color.fromARGB(255, 17, 18, 19),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          // Handle filter change
                        },
                        items: ['Harian', 'Bulanan', 'Tahunan']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Grafik Reservasi Harian',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Jadwal Lapangan Hari Ini
                  const Text(
                    'Jadwal Lapangan Hari Ini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Reservation>>(
                    future: futureReservationsToday,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error.toString()}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          'Tidak ada reservasi hari ini.',
                          style: TextStyle(color: Colors.white70),
                        ));
                      } else {
                        final reservations = snapshot.data!;
                        return Container(
                          height: 120, // Sesuaikan tinggi container
                          child: ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservation = reservations[index];
                              return Card(
                                color: Colors.white.withOpacity(0.1),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    reservation.field,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${reservation.name} - ${_formatTime(reservation.time)}', // Format waktu ke 00:00
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailJadwal(
                                            reservation: reservation),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20), // Tambahkan jarak di bagian bawah
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat statistik card
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Reservasi
class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Reservation> reservations = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedField; // Variabel untuk menyimpan lapangan yang dipilih

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final loadedReservations = await _dbHelper.getReservations();
      setState(() {
        reservations = loadedReservations;
      });
    } catch (e) {
      print('Error loading reservations: $e'); // Debugging
    }
  }

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

  Future<void> _addReservation(
      String name, String date, String time, String field) async {
    Reservation newReservation = Reservation(
      name: name,
      date: date,
      time: time,
      field: field,
    );
    await _dbHelper.insertReservation(newReservation);
    _loadReservations();
    _showFloatingNotification('Reservasi berhasil ditambahkan!');
  }

  Future<void> _editReservation(
      int id, String name, String date, String time, String field) async {
    Reservation updatedReservation = Reservation(
      id: id,
      name: name,
      date: date,
      time: time,
      field: field,
    );
    await _dbHelper.updateReservation(updatedReservation);
    _loadReservations();
    _showFloatingNotification('Reservasi berhasil diubah!');
  }

  Future<void> _deleteReservation(int id) async {
    await _dbHelper.deleteReservation(id);
    _loadReservations();
    _showFloatingNotification('Reservasi berhasil dihapus!');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 161, 13, 13),
              onPrimary: Colors.white,
              surface: Color.fromARGB(255, 17, 18, 19),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 17, 18, 19),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 161, 13, 13),
              onPrimary: Colors.white,
              surface: Color.fromARGB(255, 17, 18, 19),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 17, 18, 19),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _showReservationForm({Reservation? reservation}) {
    final TextEditingController nameController = TextEditingController();
    if (reservation != null) {
      nameController.text = reservation.name;
      selectedDate = DateTime.parse(reservation.date);
      final timeParts = reservation.time.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
      selectedField = reservation.field; // Set lapangan yang dipilih
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: const Color.fromARGB(255, 17, 18, 19),
                title: Text(
                  reservation == null ? 'Tambah Reservasi' : 'Edit Reservasi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.white),
                      title: const Text(
                        'Pilih Tanggal',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        selectedDate != null
                            ? "${selectedDate!.toLocal()}"
                                .split(' ')[0] // Tampilkan tanggal yang dipilih
                            : 'Belum dipilih', // Tampilkan "Belum dipilih" jika belum memilih
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color.fromARGB(255, 161, 13, 13),
                                  onPrimary: Colors.white,
                                  surface: Color.fromARGB(255, 17, 18, 19),
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor:
                                    const Color.fromARGB(255, 17, 18, 19),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.white),
                      title: const Text(
                        'Pilih Waktu',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        selectedTime != null
                            ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}" // Format HH:MM
                            : 'Belum dipilih', // Tampilkan "Belum dipilih" jika belum memilih
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color.fromARGB(255, 161, 13, 13),
                                  onPrimary: Colors.white,
                                  surface: Color.fromARGB(255, 17, 18, 19),
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor:
                                    const Color.fromARGB(255, 17, 18, 19),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedField,
                      dropdownColor: const Color.fromARGB(255, 17, 18, 19),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Lapangan',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      items: ['Lapangan A', 'Lapangan B']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedField = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          selectedDate != null &&
                          selectedTime != null &&
                          selectedField != null) {
                        final formattedDate =
                            "${selectedDate!.toLocal()}".split(' ')[0];
                        final formattedTime =
                            "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"; // Format waktu ke 00:00

                        if (reservation == null) {
                          _addReservation(
                            nameController.text,
                            formattedDate,
                            formattedTime,
                            selectedField!,
                          );
                        } else {
                          _editReservation(
                            reservation.id!,
                            nameController.text,
                            formattedDate,
                            formattedTime,
                            selectedField!,
                          );
                        }
                        Navigator.pop(context); // Tutup form setelah berhasil
                      }
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 17, 18, 19),
          title: const Text(
            'Hapus Reservasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus reservasi ini?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteReservation(id);
                Navigator.pop(context); // Tutup dialog setelah berhasil
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFloatingNotification(String message) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.2,
        right: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );

    // Menambahkan overlay ke dalam layar
    Overlay.of(context).insert(overlayEntry);

    // Menghapus overlay setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry?.remove();
    });
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
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: 20,
                ),
                child: const Text(
                  'Daftar Reservasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: reservations.isEmpty
                    ? const Center(
                        child: Text(
                          'Anda belum melakukan reservasi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
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
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit,
                                              color: Colors.white),
                                          title: const Text(
                                            'Edit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showReservationForm(
                                                reservation: reservation);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete,
                                              color: Colors.white),
                                          title: const Text(
                                            'Hapus',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showDeleteConfirmation(
                                                reservation.id!);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListTile(
                                title: Text(
                                  reservation.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Tanggal: ${reservation.date}, Waktu: ${_formatTime(reservation.time)}, Lapangan: ${reservation.field}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReservationForm();
        },
        backgroundColor: const Color.fromARGB(255, 161, 13, 13),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Halaman About
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul Halaman
                const Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Deskripsi Aplikasi
                const Text(
                  'Aplikasi ini dirancang untuk memenuhi tugas pengganti UAS mata kuliah Pemrograman Mobile. '
                  'Berikut link demo aplikasi:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),

                // Teks Link YouTube
                GestureDetector(
                  onTap: () {
                    // Buka link YouTube saat teks diklik
                    const url =
                        'https://youtube.com/playlist?list=PL_XRxkjvTXa2hW3cdbzGtfcjatLOhNdIN&si=h22efbUeCmSNIBE6'; // link youtube
                    launchUrl(Uri.parse(url));
                  },
                  child: const Text(
                    'Tonton Demo di YouTube',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue, // Warna teks biru seperti link
                      decoration:
                          TextDecoration.underline, // Garis bawah seperti link
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Foto Pengembang
                CircleAvatar(
                  radius: 80, // Ukuran lingkaran
                  backgroundImage:
                      AssetImage('assets/img/dev.png'), // Foto pengembang
                ),
                const SizedBox(height: 20),

                // Informasi Developer
                const Text(
                  'Dikembangkan oleh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Much Trie Harnanto\n152022083',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
