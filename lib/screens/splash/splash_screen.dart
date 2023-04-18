import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  Future<bool> initializeProvider(BuildContext context) async {
    return Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.home,
              size: 100,
            ),
            FutureBuilder(
              future: initializeProvider(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                } else {
                  if (snapshot.hasError) {
                    Future.microtask(() => Fluttertoast.showToast(
                        msg: 'Anda telah logout. Silahkan login ulang'));
                    Future.microtask(() => Navigator.pushReplacementNamed(
                        context, LoginPage.routeName));
                  }
                  if (snapshot.data == true) {
                    Future.microtask(() => Navigator.pushReplacementNamed(
                        context, HomePage.routeName));
                  } else {
                    Future.microtask(() => Navigator.pushReplacementNamed(
                        context, LoginPage.routeName));
                  }
                  return const CircularProgressIndicator.adaptive();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
