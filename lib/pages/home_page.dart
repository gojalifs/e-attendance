import 'package:flutter/material.dart';

import 'package:e_presention/pages/scan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.edit_square),
          label: const Text('Ajukan Izin Keluar'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    /// TODO avatar
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: 50,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Halo, Fajar',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Selamat Pagi!'),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 1,
                    children: [
                      MainGridView(
                        time: '06.25',
                        caption: 'Anda Sudah Presen',
                        icon: Icons.login,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ScanPage(type: 'Masuk');
                              },
                            ),
                          );
                        },
                      ),
                      MainGridView(
                        time: 'belum scan pulang',
                        caption: 'tap untuk pulang',
                        icon: Icons.logout_sharp,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ScanPage(type: 'Keluar');
                              },
                            ),
                          );
                        },
                      ),
                      const MainGridView(
                        time: '10 hari',
                        caption: 'Kehadiran Bulan Ini',
                        icon: Icons.calendar_today_sharp,
                      ),
                      const MainGridView(
                        time: '',
                        caption: 'Laporan Kehadiran',
                        icon: Icons.assignment_sharp,
                      ),
                    ],
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
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time),
                  Text(caption),
                ],
              ),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
