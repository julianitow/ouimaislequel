import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mcdo_paris/Models/User.dart';
import 'package:http/http.dart';
import 'package:mcdo_paris/Services/HTTPService.dart';
import 'package:mcdo_paris/Views/ListViewHome.dart';

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

  refresh() {
    return httpService.getUsers().then((refreshUsers) {
      setState(() {
        users = refreshUsers;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => refresh(),
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
                      itemCount: users.isEmpty ? 1 : users.length,
                      // physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        if (users.isEmpty) {
                          return const Card(
                              child: ListTile(
                            title:
                                Text('Deso y\'a une erreur, tire pour voir !'),
                            leading: Icon(Icons.error),
                            iconColor: Colors.red,
                          ));
                        }
                        return Card(
                          child: ListTile(
                            title: Text(users[index].username),
                            onTap: () {
                              Hive.openBox('user').then((box) {
                                box
                                    .put(users[index].username, users[index].id)
                                    .then((_) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ListViewHome()));
                                });
                              });
                            },
                          ),
                        );
                      }));
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
