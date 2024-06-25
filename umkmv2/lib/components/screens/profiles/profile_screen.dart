// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controllers.dart';
import '../auth/login/login_screen.dart';
import 'package:localstorage/localstorage.dart';

import '../edit_profile/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  late String email;
  late String name;
  late String phone;

  @override
  void initState() {
    super.initState();

    _loadEmailFromLocalStorage();
  }

  void _logout() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserController>(context, listen: false).logoutUser();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _loadEmailFromLocalStorage() {
    final emailFromStorage = localStorage.getItem('email');
    setState(() {
      email = emailFromStorage ?? 'Email tidak valid';
      name = localStorage.getItem('name') ?? '';
      phone = localStorage.getItem('phone') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildLoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text(
                'Akun',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('assets/image/profile.png'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          email,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()),
                            );
                          },
                          child: const Text(
                            'Lengkapi profil',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Pengaturan Akun'),
                                subtitle: const Text('Amankan Akun Sekarang'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.help),
                                title: const Text('Pusat Bantuan'),
                                subtitle:
                                    const Text('Lapor jika terjadi kesalahan'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.payments_sharp),
                                title: Row(
                                  children: [
                                    const Text(
                                      'Bayar Nanti ',
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.green,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 2.0),
                                      child: const Text(
                                        'Baru',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: const Text('Hutang yukk..'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.privacy_tip_sharp),
                                title: const Text('Syarat dan Ketentuan'),
                                subtitle: const Text('Jaga Privasimu Sekarang'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.star),
                                title: const Text('Beri Rating aplikasi'),
                                subtitle: const Text('Bantu kami beri rate'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Hubungi Kami'),
                                subtitle:
                                    const Text('Darurat? Hubungi Sekarang!!'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.corporate_fare_sharp),
                                title: Row(
                                  children: [
                                    const Text(
                                      'Kerja Sama ',
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.green,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 2.0),
                                      child: const Text(
                                        'Baru',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: const Text('Bergabung Bersama kami'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.info),
                                title: const Text('Pusat Informasi Keamanan'),
                                subtitle: const Text('Awas Datamu Bocor'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.notifications_active),
                                title: const Text('Notifikasi'),
                                subtitle:
                                    const Text('Jangan Abaikan notif yaa'),
                                onTap: () {}),
                            _buildListTile(
                                leading: const Icon(Icons.chat),
                                title:
                                    const Text('Chat dengan Customer Service'),
                                subtitle: const Text('Cepat Tanggap 24h'),
                                onTap: () {}),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.red),
                              onPressed: _logout,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Versi 1.0.0',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]));
  }

  Widget _buildListTile({
    required Widget leading,
    required Widget title,
    required Widget subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(14, 76, 175, 79),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Stack(
      children: [
        const ModalBarrier(color: Colors.black54, dismissible: false),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  backgroundColor: Colors.grey[300],
                  strokeWidth: 4,
                  semanticsLabel: 'Loading',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Logging Out...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
