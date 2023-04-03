import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:e_presention/screens/login/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_presention/utils/custom_theme.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/screens/profile_page.dart';
import 'package:e_presention/screens/report_page.dart';
import 'package:e_presention/screens/scan_page.dart';
import 'package:e_presention/screens/success_upload_page.dart';
import 'package:e_presention/screens/upload_image_page.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

void main() async {
  await initializeDateFormatting('id_ID');
  // runAppScaled(
  //   const MyApp(),
  //   scaleFactor: (deviceSize) {
  //     const double baseWidth = 449;
  //     return deviceSize.width / baseWidth;
  //   },
  // );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        UploadPage.routeName: (context) => const UploadPage(),
        SuccessPage.routeName: (context) => const SuccessPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        ReportPage.routeName: (context) => const ReportPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ScanPage.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ScanPage(
                type: args,
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name} on routes');
        return null;
      },
    );
  }
}
