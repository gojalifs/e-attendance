import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nikController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.login, size: 200),
                const SizedBox(height: 20),
                Text(
                  'Login e-Absensi',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                ),
                const SizedBox(height: 100),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: nikController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            labelText: 'No. ID',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: passController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye_rounded),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Lupa Kata Sandi'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Consumer<AuthProvider>(
                          builder: (context, value, child) => ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (formKey.currentState!.validate()) {
                                await value
                                    .login(nikController.text.trim(),
                                        passController.text.trim())
                                    .then((_) => Navigator.of(context)
                                        .pushReplacementNamed(
                                            HomePage.routeName));
                              }
                            },
                            child: const Text('LOGIN'),
                          ),
                        ),
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
