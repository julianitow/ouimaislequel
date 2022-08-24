import 'package:flutter/material.dart';
import 'package:mcdo_paris/Models/Restaurant.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant details view'),
          backgroundColor: green,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(fontSize: 25.0),
                  ),
                  const Divider(height: 15, thickness: 1, color: Colors.green),
                ]),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Addresse',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Center(child: Text(widget.restaurant.address.toString()))
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.restaurant.visited = !widget.restaurant.visited;
                      });
                    },
                    icon: widget.restaurant.visited
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  Text(widget.restaurant.visited
                      ? 'Visité'
                      : 'Pas encore visité')
                ],
              )
            ],
          ),
        ));
  }
}
