import 'package:flutter/material.dart';
import 'package:mcdo_paris/Models/Address.dart';
import 'package:mcdo_paris/Models/Restaurant.dart';
import 'package:mcdo_paris/Services/HTTPService.dart';
import 'package:mcdo_paris/Views/RestaurantDetailsView.dart';

class ListViewHome extends StatefulWidget {
  const ListViewHome({Key? key}) : super(key: key);

  @override
  State<ListViewHome> createState() => _ListViewHome();
}

class _ListViewHome extends State<ListViewHome> {
  Image icon = Image.asset('assets/logo-mcdo.png');
  late List<Restaurant> restaurants = List
      .empty(); /*[
    Restaurant(
        name: 'PARIS AUSTERLITZ',
        address: Address(
            address: '2 Boulevard de l\'Hôpital',
            zipCode: '75005',
            city: 'PARIS',
            country: 'France'),
        coordinates: [48.84309533, 2.363970569],
        visited: true),
    Restaurant(
        name: 'PARIS GARE DE LYON ORIGINALS AREAS',
        address: Address(
            address: 'Gare de Lyon Hall 3',
            zipCode: '75012',
            city: 'PARIS',
            country: 'France'),
        coordinates: [48.844631, 2.375697],
        visited: true),
  ];*/
  final HttpService httpService = HttpService();
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
          FutureBuilder(
              future: httpService.getRestaurants(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Restaurant>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 23, 65, 24)),
                  );
                }
                restaurants = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: resultRestaurantList.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(resultRestaurantList[index].name),
                            subtitle: Text(
                                resultRestaurantList[index].address.toString()),
                            leading: icon,
                            trailing: resultRestaurantList[index].visited
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantDetailsView(
                                            restaurant: restaurants[index],
                                          )));
                            },
                          ),
                        );
                      })),
                );
              }),
        ],
      )),
    );
  }
}
