import 'package:e_presention/pages/pict.dart';
import 'package:e_presention/pages/upload_image_page.dart';
import 'package:flutter/material.dart';

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

                /// TODO make qr scan
                child: const Text('Kamera Scan QR'),
              ),
              const SizedBox(height: 20),
              const Text('Arahkan kamera ke kode QR untuk melakukan absensi'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const UploadPage();
                  //     },
                  //   ),
                  // );
                  Navigator.pushNamedAndRemoveUntil(
                      context, UploadPage.routeName, (route) => true);
                },
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
