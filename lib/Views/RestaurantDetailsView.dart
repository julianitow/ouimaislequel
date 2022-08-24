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
