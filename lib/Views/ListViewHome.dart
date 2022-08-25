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
  late List<Restaurant> restaurants = List.empty();
  final HttpService httpService = HttpService();
  final TextEditingController searchController = TextEditingController();
  late List<Restaurant> resultRestaurantList = List.from(restaurants);
  int selectedFilter = 2; // All
  List<DropdownMenuItem<int>> filters = const [
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
  ];

  onSearchInputChanged(String value) {
    setState(() {
      resultRestaurantList = restaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  onFilterChanged(int? value) {
    if (value == null) {
      return;
    }
    setState(() {
      selectedFilter = value;
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

  refresh() {
    httpService.getRestaurants().then((newData) {
      setState(() {
        restaurants = newData;
        for (final data in newData) {
          if (data.visited) {
            print(data.name);
          }
        }
      });
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
                  items: filters,
                  value: selectedFilter,
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
                if (restaurants.isEmpty) {
                  return const Text('Deso y\'a eu une erreur');
                }
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
                                            restaurant:
                                                resultRestaurantList[index],
                                          ))).then((_) => refresh());
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
