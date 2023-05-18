import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:scaled_app/scaled_app.dart';

import 'data/providers/auth_provider.dart';
import 'data/providers/exit_permit_provider.dart';
import 'data/providers/leave_provider.dart';
import 'data/providers/photo_provider.dart';
import 'data/providers/presention_provider.dart';
import 'data/providers/revise_provider.dart';
import 'screens/exit_permit_page.dart';
import 'screens/home/home_page.dart';
import 'screens/leaves/leave_page.dart';
import 'screens/login/login_page.dart';
import 'screens/profile_page.dart';
import 'screens/reports_page.dart';
import 'screens/revision/revision_page.dart';
import 'screens/scanner/scan_page.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/success_upload_page.dart';
import 'utils/custom_theme.dart';

void main() async {
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      /// TODO add screen orientation check for responsive layout
      const double widthOfDesign = 411;
      return deviceSize.width / widthOfDesign;
    },
  );
  // smallest width 441 (note10pro)
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initializeDateFormatting('id_ID');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PresentProvider()),
        ChangeNotifierProvider(create: (context) => PhotoProvider()),
        ChangeNotifierProvider(create: (context) => ExitPermitProvider()),
        ChangeNotifierProvider(create: (context) => LeaveProvider()),
        ChangeNotifierProvider(create: (context) => ReviseProvider()),
      ],
      child: const MyApp(
          // homeWidget: homeRoute,
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // final Widget homeWidget;
  const MyApp({
    Key? key,
    // required this.homeWidget,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Presensi',
      theme: CustomTheme.themeData,
      home: const CustomSplashScreen(),
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        SuccessPage.routeName: (context) => const SuccessPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        ReportPage.routeName: (context) => const ReportPage(),
        ExitPermitPage.routeName: (context) => const ExitPermitPage(),
        LeavePage.routeName: (context) => const LeavePage(),
        RevisionPage.routeName: (context) => const RevisionPage(),
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
