import 'package:flutter/material.dart';

import 'package:e_presention/screens/profile_page.dart';
import 'package:e_presention/screens/report_page.dart';
import 'package:e_presention/screens/scan_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String greeting = '';
  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  void _updateGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 10 && hour >= 5) {
      greeting = "Pagi!";
    } else if (hour < 15) {
      greeting = "Siang!";
    } else if (hour < 19) {
      greeting = 'Sore!';
    } else {
      greeting = 'Malam!';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData style = Theme.of(context);
    return GestureDetector(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.edit_square),
          label: const Text('Ajukan Izin Keluar'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.routeName);
                  },
                  child: Row(
                    children: [
                      /// TODO avatar
                      const Expanded(
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: 75,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Halo, Rudi',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Selamat $greeting',
                              style: style.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Kehadiran Anda',
                          style: style.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 1.5,
                          children: [
                            MainGridView(
                              time: '06.25',
                              caption: 'Anda Sudah Presen',
                              icon: Icons.login,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ScanPage.routeName,
                                  arguments: 'masuk',
                                );
                              },
                            ),
                            MainGridView(
                              time: 'belum scan pulang',
                              caption: 'tap untuk pulang',
                              icon: Icons.logout_sharp,
                              onTap: () {
                                Navigator.pushNamed(context, ScanPage.routeName,
                                    arguments: 'pulang');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Laporan Bulan Ini',
                          style: style.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 1.5,
                          children: [
                            const MainGridView(
                              time: '10 hari',
                              caption: 'Kehadiran Bulan Ini',
                              icon: Icons.calendar_today_sharp,
                            ),
                            MainGridView(
                              time: '',
                              caption:
                                  'Tap Untuk Laporan Kehadiran Lebih Lengkap',
                              icon: Icons.assignment_sharp,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ReportPage.routeName,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainGridView extends StatelessWidget {
  final String time;
  final String caption;
  final IconData icon;
  final Function()? onTap;

  const MainGridView({
    Key? key,
    required this.time,
    required this.caption,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData style = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: !time.contains('belum')
            ? const Color.fromRGBO(36, 219, 122, 1)
            : Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  icon,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    time,
                    style: time.contains(RegExp(r'[0-9]'))
                        ? style.textTheme.titleLarge
                        : style.textTheme.titleSmall
                            ?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  caption,
                  style: style.textTheme.bodyMedium
                      ?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
