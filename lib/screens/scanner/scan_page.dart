import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/providers/photo_provider.dart';
import '../../data/providers/presention_provider.dart';
import '../success_upload_page.dart';

class ScanPage extends StatefulWidget {
  static const routeName = '/scan';
  final String type;
  const ScanPage({
    Key? key,
    this.type = '',
  }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Position? location;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    Provider.of<PresentProvider>(context, listen: false).initScan();
    location =
        await Provider.of<PhotoProvider>(context, listen: false).getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan untuk ${widget.type}',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: 0.9 * MediaQuery.of(context).size.width,
                height: 0.6 * MediaQuery.of(context).size.height,
                child: Consumer<PhotoProvider>(
                  builder: (context, scan, child) {
                    if (scan.state == ConnectionState.waiting ||
                        scan.state == ConnectionState.done) {
                      return const Center(
                        child: Text('Uploading'),
                      );
                    }
                    if ((scan.permission == LocationPermission.always ||
                            scan.permission == LocationPermission.whileInUse) &&
                        scan.status == PermissionStatus.granted) {
                      return MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                          detectionTimeoutMs: 2000,
                        ),
                        onDetect: (capture) async {
                          final List<Barcode> barcodes = capture.barcodes;
                          String type = '';
                          String code = barcodes.first.rawValue!;

                          /// Check for qrcode value
                          if (code.contains('checkin') &&
                              widget.type == 'masuk') {
                            type = 'masuk';
                          } else if (code.contains('checkout') &&
                              widget.type == 'pulang') {
                            type = 'pulang';
                          } else {
                            MotionToast.error(
                              description: const Text(
                                  'Kode Tidak Dikenali, mungkin anda salah scan?'),
                            ).show(context);
                            return;
                          }
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                contentPadding: const EdgeInsets.all(20),
                                content: Wrap(
                                  runSpacing: 20,
                                  children: [
                                    Text(
                                      '''Mohon Tunggu, Silahkan anda ambil foto selfie, \n'''
                                      '''Pastikan muka anda terlihat jelas di kamera.''',
                                      style: style.textTheme.headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const Center(
                                        child: CircularProgressIndicator()),
                                  ],
                                ),
                              );
                            },
                          );

                          await Future.delayed(const Duration(seconds: 3))
                              .then((value) => Navigator.of(context).pop());

                          await scan.getPict();
                          if (!mounted) {
                            return;
                          }
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Wrap(
                                  children: [
                                    Text(
                                      'Mohon Tunggu, sedang menyiapkan data anda',
                                      style: style.textTheme.headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            },
                          );
                          await scan.sendPresention(type).then(
                            (value) async {
                              Navigator.of(context).pop();
                              await Provider.of<PresentProvider>(context,
                                      listen: false)
                                  .getTodayPresention(DateTime.now());
                              if (!mounted) {
                                return null;
                              }

                              return Navigator.pushReplacementNamed(
                                context,
                                SuccessPage.routeName,
                                arguments: type,
                              );
                            },
                          ).onError(
                            (error, stackTrace) {
                              Provider.of<PresentProvider>(context,
                                          listen: false)
                                      .state ==
                                  ConnectionState.none;
                              return MotionToast.error(
                                description:
                                    const Text('Something Error Happened'),
                              ).show(context);
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: InkWell(
                          onTap: () async {
                            scan.getLocation();
                          },
                          child: const Text(
                            '''Aplikasi ini membutuhkan akses lokasi yang '''
                            '''presisi dan kamera. Tekan untuk meminta akses lokasi/kamera.''',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Arahkan kamera ke kode QR untuk melakukan absensi'),
            ],
          ),
        ),
      ),
    );
  }
}
