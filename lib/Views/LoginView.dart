import 'package:flutter/material.dart';
import 'package:mcdo_paris/Models/User.dart';
import 'package:http/http.dart';
import 'package:mcdo_paris/Services/HTTPService.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  Image icon = Image.asset('assets/logo-mcdo.png');
  HttpService httpService = HttpService();
  final TextEditingController passwordController = TextEditingController();
  late List<User> users =
      List.empty(); // [User(username: 'Noémie'), User(username: 'Julien')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: icon,
              ),
            ),
            const Text(
              'Qui suis-je ?',
              style: TextStyle(fontSize: 20),
            ),
            const Divider(height: 15, thickness: 1, color: Colors.green),
            FutureBuilder(
              future: httpService.getUsers(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 23, 65, 24)),
                  );
                }
                users = snapshot.data!;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(users[index].username),
                          onTap: () {
                            print(users[index].username);
                            print(users[index].id);
                          },
                        ),
                      );
                    }));
              },
            ),
          ],
        ),
      )),
    );
  }
}
