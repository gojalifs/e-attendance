import 'package:e_presention/data/providers/presention_provider.dart';
import 'package:e_presention/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:scaled_app/scaled_app.dart';

import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/screens/home/home_page.dart';
import 'package:e_presention/screens/login/login_page.dart';
import 'package:e_presention/screens/profile_page.dart';
import 'package:e_presention/screens/report_page.dart';
import 'package:e_presention/screens/scan_page.dart';
import 'package:e_presention/screens/success_upload_page.dart';
import 'package:e_presention/screens/upload_image_page.dart';
import 'package:e_presention/services/sqflite_service.dart';
import 'package:e_presention/utils/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  // runAppScaled(
  //   const MyApp(),
  //   scaleFactor: (deviceSize) {
  //     const double baseWidth = 449;
  //     return deviceSize.width / baseWidth;
  //   },
  // );
  SqfLiteService service = SqfLiteService();
  Widget homeRoute = const LoginPage();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? value = preferences.getBool('isLoggedIn') ?? false;
  // await service.checkLoginStatus().then((value) {
  if (!value) {
    homeRoute = const HomePage();
  } else {
    homeRoute = const LoginPage();
  }
  // });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PresentProvider()),
      ],
      child: MyApp(
        homeWidget: homeRoute,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homeWidget;
  const MyApp({
    Key? key,
    required this.homeWidget,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.themeData,
      // initialRoute: '/',
      home: const CustomSplashScreen(),
      routes: {
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
