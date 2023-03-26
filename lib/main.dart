import 'package:intl/date_symbol_data_local.dart';
import 'package:e_presention/custom_theme.dart';
import 'package:e_presention/pages/home_page.dart';
import 'package:e_presention/pages/profile_page.dart';
import 'package:e_presention/pages/report_page.dart';
import 'package:e_presention/pages/scan_page.dart';
import 'package:e_presention/pages/success_upload_page.dart';
import 'package:e_presention/pages/upload_image_page.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

void main() async {
  await initializeDateFormatting('id_ID');
  runAppScaled(
    const MyApp(),
    scaleFactor: (deviceSize) {
      const double baseWidth = 449;
      return deviceSize.width / baseWidth;
    },
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
      home: const HomePage(),
      initialRoute: HomePage.routeName,
      routes: {
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
