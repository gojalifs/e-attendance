import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/models/user.dart';
import '../data/providers/auth_provider.dart';
import 'login/login_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

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
                                    'http://192.168.128.22/storage/${user.avaPath!}')
                                : const AssetImage('assets/images/user.jpeg')
                                    as ImageProvider,
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

                              /// TODO
                              /// save to sqlite
                              /// fix the avatar
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

class BiodataWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String column;
  final Function()? onPressed;

  const BiodataWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.column,
    this.onPressed,
  }) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(title)),
          Expanded(
            flex: 3,
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: title == 'No. ID'
                  ? const SizedBox()
                  : const Icon(Icons.edit_square),
              onPressed: title == 'No. ID'
                  ? null
                  : () {
                      final TextEditingController controller =
                          TextEditingController(text: subtitle);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          contentPadding: const EdgeInsets.all(20),
                          content: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 20,
                            children: [
                              Text(
                                title.contains('Kelamin')
                                    ? 'Ubah data $title (L/P)'
                                    : 'Ubah data $title',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: title == 'E-mail'
                                      ? [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(r'[\s]'),
                                          )
                                        ]
                                      : title.contains('Kelamin')
                                          ? [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[L,P]'),
                                              )
                                            ]
                                          : null,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                  controller: controller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<AuthProvider>(
                                    builder: (context, value, child) =>
                                        ElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!.validate()) {
                                          await value.updateProfile(
                                              column, controller.text);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: Theme.of(context)
                                        .elevatedButtonTheme
                                        .style!
                                        .copyWith(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.red),
                                        ),
                                    child: const Text('Batal'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
