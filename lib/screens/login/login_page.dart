import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/data/providers/presention_provider.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
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
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
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
                        child: Consumer2<AuthProvider, PresentProvider>(
                          builder: (context, auth, present, child) {
                            if (auth.connectionState !=
                                ConnectionState.active) {
                              return ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', true);
                                  if (formKey.currentState!.validate()) {
                                    await auth
                                        .login(nikController.text.trim(),
                                            passController.text.trim())
                                        .then(
                                      (_) async {
                                        await present.getPresention(
                                            auth.user!.nik!, auth.user!.token!);

                                        if (!mounted) {
                                          return null;
                                        }
                                        return Navigator.of(context)
                                            .pushReplacementNamed(
                                                HomePage.routeName);
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        print(error);
                                        return MotionToast.warning(
                                          title: const Text('Login Failed'),
                                          description: Text(
                                            error.toString(),
                                          ),
                                        ).show(context);
                                      },
                                    );
                                  }
                                },
                                child: const Text('LOGIN'),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            }
                          },
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
