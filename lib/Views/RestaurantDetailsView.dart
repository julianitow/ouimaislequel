import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mcdo_paris/Models/Restaurant.dart';
import 'package:mcdo_paris/Services/HTTPService.dart';

class RestaurantDetailsView extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsView({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RestaurantDetailsView();
}

class _RestaurantDetailsView extends State<RestaurantDetailsView> {
  Image icon = Image.asset('assets/logo-mcdo.png');
  Color green = const Color.fromARGB(255, 24, 100, 30);
  HttpService httpService = HttpService();

  openInMap(context) async {
    final latitude = widget.restaurant.coordinates[0];
    final longitude = widget.restaurant.coordinates[1];
    try {
      final coords = Coords(latitude, longitude);
      final title = widget.restaurant.name;
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deso y\'a eu une erreur')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String visitedDate = widget.restaurant.date ?? "aujourd'hui";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: green,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: icon,
                  ),
                  Text(
                    widget.restaurant.name,
                    style: const TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 15, thickness: 1, color: Colors.green),
                ]),
              )),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectableText.rich(
                                TextSpan(
                                  text: widget.restaurant.address
                                      .address, // default text style
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.restaurant.address.zipCode,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    const TextSpan(text: ', '),
                                    TextSpan(
                                      text: widget.restaurant.address.city,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () => openInMap(context),
                                child: Row(
                                  children: const [
                                    Icon(Icons.map),
                                    Text('Guide moi')
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    widget.restaurant.visited =
                                        !widget.restaurant.visited;
                                    httpService
                                        .updateRestaurant(widget.restaurant)
                                        .then(
                                      (res) {
                                        if (res != 201) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Deso y\'a eu une erreur')));
                                        }
                                      },
                                    );
                                  });
                                },
                                child: Row(children: [
                                  widget.restaurant.visited
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  Text(widget.restaurant.visited
                                      ? 'Visité le $visitedDate'
                                      : 'Pas encore visité')
                                ]),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
