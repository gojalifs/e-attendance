import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  final String type;
  const ScanPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    width: 0.7 * double.infinity,
                    height: 600,

                    /// TODO change this
                    child: const Text('Kamera Scan QR'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                      'Arahkan kamera ke kode QR untuk melakukan absensi'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Scan untuk ${widget.type}',
                    style: const TextStyle(fontSize: 50),
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
