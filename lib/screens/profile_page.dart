import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/models/user.dart';
import '../data/providers/auth_provider.dart';
import '../env/env.dart';
import '../utils/common_widget.dart';
import 'login/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String baseUrl = Env.url.replaceAll(RegExp(r'api'), '');
  static const routeName = '/profile';
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Hero(
                tag: 'avatar',
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Consumer<AuthProvider>(
                        builder: (context, value, child) {
                          User user = value.user!;
                          return CircleAvatar(
                            radius: 100,
                            backgroundImage: user.avaPath! != '-'
                                ? NetworkImage(
                                    '${baseUrl}storage/${user.avaPath!}')
                                : null,
                            child: user.avaPath! != '-'
                                ? null
                                : const Icon(
                                    Icons.account_circle_rounded,
                                    size: 200,
                                  ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.25,
                      child: Consumer<AuthProvider>(
                        builder: (context, value, child) => Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () async {
                              final pict = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              var filePath = pict!.path;
                              var targetPath = '${filePath}_compressed.jpg';
                              File? compressed =
                                  await FlutterImageCompress.compressAndGetFile(
                                filePath,
                                targetPath,
                                quality: 25,
                              );
                              File? image = File(compressed!.path);
                              value.updateAvatar(image);
                            },
                            icon: const Icon(Icons.edit_square),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Colors.grey.shade200,
                  border: const Border.symmetric(),
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    User user = value.user!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          BiodataWidget(
                            title: 'Nama',
                            subtitle: user.nama!,
                            column: 'nama',
                          ),
                          BiodataWidget(
                            title: 'No. ID',
                            subtitle: user.nik!,
                            column: 'nik',
                          ),
                          BiodataWidget(
                            title: 'NIPNS',
                            subtitle: user.nipns ?? '-',
                            column: 'nipns',
                          ),
                          BiodataWidget(
                            title: 'E-mail',
                            subtitle: user.email!,
                            column: 'email',
                          ),
                          BiodataWidget(
                            title: 'HP',
                            subtitle: user.telp!,
                            column: 'telp',
                          ),
                          BiodataWidget(
                              title: 'Jenis Kelamin',
                              subtitle: user.gender!,
                              column: 'gender'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: () async {
                        await value.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginPage.routeName, (route) => false);
                        }
                      },
                      child: const Text('Logout')),
                ),
              )),
        ],
      ),
    );
  }
}
