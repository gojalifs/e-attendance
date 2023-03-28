import 'package:e_presention/screens/success_upload_page.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  static const routeName = '/upload_page';
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isTaken = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isTaken
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isTaken = !isTaken;
                  });
                },
                icon: const Icon(Icons.photo_camera_sharp),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Tekan Untuk mengambil foto ${isTaken ? 'ulang' : 'anda'}'),
            const SizedBox(height: 20),
            isUploading
                ? const CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: isTaken
                        ? () {
                            isUploading = true;
                            setState(() {});

                            /// TODO change with response from server
                            ///
                            /// kirim foto ke success page
                            Future.delayed(Duration(seconds: 1)).then(
                              (value) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    SuccessPage.routeName, (route) => true);
                              },
                            );
                          }
                        : null,
                    child: const Text('Upload'),
                  ),
          ],
        ),
      ),
    );
  }
}
