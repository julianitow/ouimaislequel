import 'package:flutter/material.dart';
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
  late Future<List<Restaurant>> getRestaurants;
  int visitedCount = 0;
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
    return httpService.getRestaurants().then((newData) {
      for (final restaurant in newData) {
        if (restaurant.visited) {
          visitedCount++;
        }
      }
      setState(() {
        selectedFilter = 2; // all
        restaurants = newData;
        resultRestaurantList = restaurants;
      });
    }).catchError((err) {
      print(err);
    });
  }

  dismissKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    getRestaurants = httpService.getRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    visitedCount = 0;
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
                      decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          suffixIcon: IconButton(
                              onPressed: () {
                                dismissKeyboard(context);
                                searchController.clear();
                                refresh();
                              },
                              icon: const Icon(Icons.clear))),
                      onChanged: onSearchInputChanged),
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
              future: getRestaurants,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Restaurant>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 23, 65, 24)),
                  );
                }
                restaurants = snapshot.data!;
                for (final restaurant in restaurants) {
                  if (restaurant.visited) {
                    visitedCount++;
                  }
                }
                int left = restaurants.length - visitedCount;
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => refresh(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                height: 50,
                                child: Card(
                                    child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              9),
                                      child: const Icon(Icons.restaurant),
                                    ),
                                    Text('Goutés: $visitedCount'),
                                  ],
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                height: 50,
                                child: Card(
                                    child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              9),
                                      child: const Icon(Icons.restaurant),
                                    ),
                                    Text('Dispos: $left'),
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: resultRestaurantList.isEmpty
                                  ? 1
                                  : resultRestaurantList.length,
                              itemBuilder: ((context, index) {
                                if (resultRestaurantList.isEmpty) {
                                  return const Card(
                                      child: ListTile(
                                    title: Text(
                                        'Deso y\'a une erreur, tire pour voir'),
                                    leading: Icon(Icons.error),
                                    iconColor: Colors.red,
                                  ));
                                }
                                return Card(
                                  child: ListTile(
                                    title:
                                        Text(resultRestaurantList[index].name),
                                    subtitle: Text(resultRestaurantList[index]
                                        .address
                                        .toString()),
                                    leading: icon,
                                    trailing:
                                        resultRestaurantList[index].visited
                                            ? const Icon(Icons.check)
                                            : null,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RestaurantDetailsView(
                                                    restaurant:
                                                        resultRestaurantList[
                                                            index],
                                                  ))).then((_) {
                                        refresh();
                                        dismissKeyboard(context);
                                        searchController.clear();
                                      });
                                    },
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      )),
    );
  }
}
