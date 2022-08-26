import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mcdo_paris/Views/ListViewHome.dart';
import 'package:mcdo_paris/Views/LoginView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static Future<Widget> startApp(BuildContext context) async {
    await Hive.initFlutter();
    var box = await Hive.openBox('user');
    if (box.get('user_id') != null) {
      String id = box.get('user_id');
    } else {
      return LoginView();
    }
    return const ListViewHome();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Macdo-Paname',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        darkTheme:
            ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
        themeMode: ThemeMode.system,
        home: FutureBuilder(
          future: startApp(context),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }
            return snapshot.data!;
          },
        ));
  }
}
