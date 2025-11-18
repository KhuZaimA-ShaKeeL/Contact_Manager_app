import 'package:contactappp/provider/ThemeProvider.dart';
import 'package:contactappp/provider/contactProvider.dart';
import 'package:contactappp/screens/HomeScreens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? themeMode = prefs.getString("themeMode");
  runApp(MyApp(themeMode: themeMode));
}

class MyApp extends StatelessWidget {
  final String? themeMode;
  const MyApp({super.key, this.themeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => Themeprovider(initialTheme: themeMode)),
      ],
      child: Consumer<Themeprovider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            themeMode: themeProvider.currentTheme,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.light),
              useMaterial3: true,
            ),
            home: Homescreen()
          );
        }
      )
    );
  }
}

