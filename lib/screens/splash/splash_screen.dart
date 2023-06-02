import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/helper/database_helper.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  Future<bool> initializeProvider(BuildContext context) async {
    return await Provider.of<AuthProvider>(context, listen: false)
        .checkLoginStatus();
  }

  void check() async {
    try {
      bool status = await initializeProvider(context);
      if (!mounted) {
        return;
      }
      if (status) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    } catch (e) {
      await DBHelper().deleteDb();
      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }

  @override
  void initState() {
    check();
    // Provider.of<PresentProvider>(context, listen: false).presentionCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset('assets/images/logo-smp.png'),
            ),
            const CircularProgressIndicator(),
            // FutureBuilder(
            //   future: initializeProvider(context),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const CircularProgressIndicator.adaptive();
            //     } else {
            //       if (snapshot.hasError) {
            //         Future.microtask(() => Fluttertoast.showToast(
            //             msg: 'Anda telah logout. Silahkan login ulang'));
            //         Future.microtask(() => Navigator.pushReplacementNamed(
            //             context, LoginPage.routeName));
            //       }
            //       if (snapshot.data == true) {
            //         Future.microtask(() => Navigator.pushReplacementNamed(
            //             context, HomePage.routeName));
            //       } else {
            //         Future.microtask(() => Navigator.pushReplacementNamed(
            //             context, LoginPage.routeName));
            //       }
            //       return const CircularProgressIndicator.adaptive();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
