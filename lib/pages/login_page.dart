import 'package:e_presention/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
              child: Column(
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'No. ID',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ));
                            },
                            child: const Text('LOGIN'),
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
      ),
    );
  }
}
