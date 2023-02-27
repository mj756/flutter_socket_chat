import 'package:flutter/material.dart';
import 'package:learning/constants/app_constant.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:learning/view/home.dart';
import 'package:learning/view/login.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceController.initPreference();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        PreferenceController.getBoolean(AppConstant.isLoggedIn);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.purple,
        appBarTheme: AppBarTheme(
            color: Colors.purple,
            elevation: 4,
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white, size: 16),
            foregroundColor: Colors.white, //<-
            titleTextStyle: Theme.of(context).textTheme.bodyMedium),
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: Colors.purple,
          suffixIconColor: Colors.purple,
          hintStyle: TextStyle(color: Colors.black, fontSize: 12),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 46.0, fontStyle: FontStyle.italic),
          titleMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          titleSmall: TextStyle(fontSize: 26.0, fontStyle: FontStyle.italic),
          bodyLarge: TextStyle(
            fontSize: 17.0,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
          ),
          bodySmall: TextStyle(
            fontSize: 12.0,
          ),
        ),
        iconTheme: const IconThemeData(
          size: 16,
          color: Colors.purple,
        ),
      ),
      home: isLoggedIn ? const HomePage() : Login(),
    );
  }
}
