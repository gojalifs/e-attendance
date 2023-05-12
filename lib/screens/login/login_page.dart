import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/presention_provider.dart';
import '../../env/env.dart';
import '../home/home_page.dart';

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
  bool isVisible = true;
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
                Image.asset('assets/images/logo-smp.png'),
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
                          obscureText: isVisible,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              icon: isVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
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
                                  print(Env.url);
                                  if (formKey.currentState!.validate()) {
                                    await auth
                                        .login(nikController.text.trim(),
                                            passController.text.trim())
                                        .then(
                                      (_) async {
                                        // await present.getPresention(
                                        //     auth.user!.nik!, auth.user!.token!);
                                        await present
                                            .getTodayPresention(DateTime.now());
                                        if (!mounted) {
                                          return null;
                                        }
                                        return Navigator.of(context)
                                            .pushReplacementNamed(
                                                HomePage.routeName);
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        return MotionToast.warning(
                                          title: const Text('Login Failed'),
                                          description: const Text(
                                            'Check Your ID or Password',
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
