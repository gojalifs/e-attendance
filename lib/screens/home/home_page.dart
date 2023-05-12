import 'package:e_presention/screens/revision/revision_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/data/providers/presention_provider.dart';
import 'package:e_presention/screens/exit_permit_page.dart';
import 'package:e_presention/screens/leaves/leave_page.dart';
import 'package:e_presention/screens/profile_page.dart';
import 'package:e_presention/screens/reports_page.dart';
import 'package:e_presention/screens/scanner/scan_page.dart';

import '../../env/env.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String baseUrl = Env.url.replaceAll(RegExp(r'api'), '');

  String greeting = '';
  @override
  void initState() {
    print(baseUrl);
    _updateGreeting();
    super.initState();
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
    Provider.of<PresentProvider>(context, listen: false).getTodayPresention(
      DateTime.now(),
    );
    Provider.of<PresentProvider>(context, listen: false).presentionCount();
    return GestureDetector(
      child: Scaffold(
        body: SafeArea(
          child: Consumer2<PresentProvider, AuthProvider>(
            builder: (context, present, auth, child) => RefreshIndicator(
              onRefresh: () async {
                await present.getTodayPresention(DateTime.now());
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ProfilePage.routeName);
                      },
                      child: Consumer<AuthProvider>(
                        builder: (context, value, child) => Row(
                          children: [
                            Hero(
                              tag: 'avatar',
                              child: value.user!.avaPath! == '-' ||
                                      value.user!.avaPath!.isEmpty
                                  ? const Icon(
                                      Icons.account_circle_rounded,
                                      size: 75,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(75),
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        '${Env.imageUrl}/${value.user!.avaPath!}',
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    'Halo, ${value.user!.nama}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                          Consumer<PresentProvider>(
                            builder: (context, value, child) {
                              String timeIn;
                              if (value.today.isNotEmpty &&
                                  value.today[0].nik!.isNotEmpty) {
                                timeIn = value.today[0].time!;
                              } else {
                                timeIn = 'Anda Belum Scan';
                              }
                              String timeOut;
                              if (value.today.length > 1 &&
                                  value.today[1].nik!.isNotEmpty) {
                                timeOut = value.today[1].time!;
                              } else {
                                timeOut = 'Anda Belum Scan';
                              }

                              return GridView.count(
                                primary: false,
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 1.5,
                                children: [
                                  MainGridView(
                                    time: timeIn,
                                    caption: timeIn.contains('Belum')
                                        ? 'Tap untuk masuk'
                                        : 'Anda Sudah Presen',
                                    icon: Icons.login,
                                    onTap: timeIn.contains('Belum')
                                        ? () {
                                            Navigator.pushNamed(
                                              context,
                                              ScanPage.routeName,
                                              arguments: 'masuk',
                                            );
                                          }
                                        : null,
                                  ),
                                  MainGridView(
                                    time: timeOut.isEmpty
                                        ? 'belum scan pulang'
                                        : timeOut,
                                    caption: timeIn.contains('Belum')
                                        ? 'Tap untuk pulang'
                                        : 'Anda Sudah Presen',
                                    icon: Icons.logout_sharp,
                                    onTap: timeOut.contains('Belum')
                                        ? () {
                                            Navigator.pushNamed(
                                                context, ScanPage.routeName,
                                                arguments: 'pulang');
                                          }
                                        : null,
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Laporan Bulan Ini',
                              style: style.textTheme.titleMedium,
                            ),
                          ),
                          GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 1.5,
                            children: [
                              Consumer<PresentProvider>(
                                builder: (context, value, child) =>
                                    MainGridView(
                                  time: '${value.count} Hari',
                                  caption: 'Kehadiran Bulan Ini',
                                  icon: Icons.calendar_today_sharp,
                                ),
                              ),
                              MainGridView(
                                time: '',
                                caption:
                                    'Tap Untuk Laporan Kehadiran Lebih Lengkap',
                                icon: Icons.assignment_sharp,
                                color: style.colorScheme.secondary,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ReportPage.routeName,
                                  );
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Ajukan Sesuatu',
                              style: style.textTheme.titleMedium,
                            ),
                          ),
                          GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: [
                              MainGridView(
                                time: 'Ajukan Izin Keluar',
                                caption: '',
                                color: const Color.fromRGBO(36, 219, 122, 1),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ExitPermitPage.routeName);
                                },
                              ),
                              MainGridView(
                                time: 'Ajukan Cuti, Izin Tidak Masuk',
                                caption: '',
                                color: const Color.fromRGBO(36, 219, 122, 1),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(LeavePage.routeName);
                                },
                              ),
                              MainGridView(
                                time: 'Ajukan Revisi Absen',
                                caption: '',
                                color: const Color.fromRGBO(36, 219, 122, 1),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RevisionPage.routeName);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
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

class MainGridView extends StatelessWidget {
  final String time;
  final String caption;
  final IconData? icon;
  final Color? color;
  final Function()? onTap;

  const MainGridView({
    Key? key,
    required this.time,
    required this.caption,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData style = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color ??
            (time.contains(RegExp(r'[0-9]'))
                ? const Color.fromRGBO(36, 219, 122, 1)
                : Colors.red),
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
                    maxLines: 4,
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
