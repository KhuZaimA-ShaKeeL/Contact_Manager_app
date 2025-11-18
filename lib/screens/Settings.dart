import 'package:contactappp/provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: Center(
        child: ExpansionTile(
          title: Text("Theme Setting"),
          children: [
            RadioListTile(
              value: ThemeMode.light,
              groupValue: themeProvider.currentTheme,
              onChanged:
                  (value) => {if (value != null) themeProvider.setTheme(value)},
              title: Text("Light Mode"),
            ),
            RadioListTile(
              value: ThemeMode.dark,
              groupValue: themeProvider.currentTheme,
              onChanged:
                  (value) => {if (value != null) themeProvider.setTheme(value)},
              title: Text("Dark Mode"),
            ),
            RadioListTile(
              value: ThemeMode.system,
              groupValue: themeProvider.currentTheme,
              onChanged:
                  (value) => {if (value != null) themeProvider.setTheme(value)},
              title: Text("System Mode"),
            ),
          ],
        ),
      ),
    );
  }
}
