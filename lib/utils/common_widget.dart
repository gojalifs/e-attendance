import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/providers/auth_provider.dart';

/// TODO delete this
// String tempUrl = 'http://192.168.165.241/storage';
// String url = 'http://192.168.46.241:81/api';
// String imageUrl = 'http://192.168.46.241:81/storage';

class CustomWidget {
  static Widget divider = const Divider(
    thickness: 2,
    color: Colors.black38,
    indent: 10,
    endIndent: 10,
  );
}

class BiodataWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String column;
  final Function()? onPressed;
  final bool? isProfilePage;

  const BiodataWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.column,
    this.onPressed,
    this.isProfilePage = true,
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
              icon: title == 'No. ID' || title == 'NIPNS' || !isProfilePage!
                  ? const SizedBox()
                  : const Icon(Icons.edit_square),
              onPressed: title == 'No. ID' ||
                      title == 'NIPNS' ||
                      !isProfilePage!
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
                                              const MaterialStatePropertyAll(
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
