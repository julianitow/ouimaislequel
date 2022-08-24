import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Address {
  String address;
  String zipCode;
  String city;
  String country;
  Address(
      {required this.address,
      required this.zipCode,
      required this.city,
      required this.country});

  @override
  String toString() {
    return '$address, $zipCode, $city';
  }

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(
        address: parsedJson['address1'].toString(),
        zipCode: parsedJson['zipCode'].toString(),
        city: parsedJson['city'].toString(),
        country: parsedJson['country'].toString());
  }
}

class Restaurant {
  String name;
  Address address;
  List<double> coordinates;
  bool visited = false;
  late int note;

  Restaurant(
      {required this.name, required this.address, required this.coordinates});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
        name: parsedJson['name'].toString(),
        address: Address.fromJson(parsedJson['restaurantAddress'][0]),
        coordinates: [
          parsedJson['coordinates']['latitude'],
          parsedJson['coordinates']['longitude']
        ]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const ListViewHome());
  }
}

class ListViewHome extends StatefulWidget {
  const ListViewHome({Key? key}) : super(key: key);

  @override
  State<ListViewHome> createState() => _ListViewHome();
}

class _ListViewHome extends State<ListViewHome> {
  Image icon = Image.asset('assets/logo-mcdo.png');
  final titles = [
    "mcdo 1",
    "mcdo 2",
    "mcdo 3",
    "mcdo 4",
    "mcdo 5",
    "mcdo 6",
    "mcdo 7",
    "mcdo 8",
    "mcdo 9",
    "mcdo 10"
  ];
  final subtitles = [
    "subtitle mcdo 1",
    "subtitle mcdo 2",
    "subtitle mcdo 3",
    "subtitle mcdo 4",
    'subtitle mcdo 5',
    'subtitle mcdo 6',
    'subtitle mcdo 7',
    'subtitle mcdo 8',
    'subtitle mcdo 9',
    'subtitle mcdo 10'
  ];

  final List<Restaurant> restaurants = [
    Restaurant(
        name: 'PARIS AUSTERLITZ',
        address: Address(
            address: '2 Boulevard de l\'Hôpital',
            zipCode: '75005',
            city: 'PARIS',
            country: 'France'),
        coordinates: [48.84309533, 2.363970569]),
    Restaurant(
        name: 'PARIS GARE DE LYON ORIGINALS AREAS',
        address: Address(
            address: 'Gare de Lyon Hall 3',
            zipCode: '75012',
            city: 'PARIS',
            country: 'France'),
        coordinates: [48.844631, 2.375697]),
  ];

  final TextEditingController searchController = TextEditingController();
  late List<Restaurant> resultRestaurantList = List.from(restaurants);

  onSearchInputChanged(String value) {
    setState(() {
      resultRestaurantList = restaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  onFilterChanged(int? value) {
    setState(() {
      switch (value) {
        case 0:
          resultRestaurantList = restaurants
              .where((restaurant) => restaurant.visited == true)
              .toList();
          break;
        case 1:
          resultRestaurantList = restaurants
              .where((restaurant) => restaurant.visited == false)
              .toList();
          break;
        case 2:
          resultRestaurantList = restaurants.toList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    restaurants[1].visited = true;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration:
                        const InputDecoration(hintText: 'Rechercher...'),
                    onChanged: onSearchInputChanged,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Visité'),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Pas encore visité'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Tous'),
                    )
                  ],
                  icon: const Icon(Icons.filter_alt),
                  onChanged: onFilterChanged,
                ),
              )
            ],
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: resultRestaurantList.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(resultRestaurantList[index].name),
                    subtitle:
                        Text(resultRestaurantList[index].address.toString()),
                    leading: icon,
                    trailing: resultRestaurantList[index].visited
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetailsView(
                                    restaurant: restaurants[index],
                                  )));
                    },
                  ),
                );
              })),
        ],
      )),
    );
  }
}

class RestaurantDetailsView extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsView({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RestaurantDetailsView();
}

class _RestaurantDetailsView extends State<RestaurantDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant details view'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Text(widget.restaurant.name),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back to list'),
              )
            ],
          ),
        ));
  }
}
