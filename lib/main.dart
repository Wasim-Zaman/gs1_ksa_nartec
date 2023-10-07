import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/localization/local_string.dart';
import 'package:gs1_v2_project/providers/gtin.dart';
import 'package:gs1_v2_project/providers/login_provider.dart';
import 'package:gs1_v2_project/res/routes/routes_management.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String routeName = 'gs1-login-screen';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GTIN>(
          create: (context) => GTIN(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
      ],
      child: GetMaterialApp(
        translations: LocalString(),
        locale: const Locale('en', 'US'),
        title: 'GS1 V2',
        theme: ThemeData(
          primarySwatch: darkBlue,
          appBarTheme: AppBarTheme(
            elevation: 0,
            toolbarTextStyle: const TextTheme().bodyMedium,
            titleTextStyle: const TextTheme().titleLarge,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: RoutesManagement.getRoutes(),
      ),
    );
  }
}
