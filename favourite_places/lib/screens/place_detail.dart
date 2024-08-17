import 'package:favorite_places/screens/Map.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;
  String get locationImage {
    final lat = place.location.lantitude;
    final lon = place.location.longitude;
    return 'https://maps.geoapify.com/v1/staticmap?style=osm-carto&width=600&height=400&center=lonlat:$lon,$lat&zoom=16&marker=lonlat:$lon,$lat;type:material;color:%23ff3421;icontype:awesome&apiKey=ecbb1ee1ee774a3d8130758c45820e43';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MapScreen(location: place.location),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                          locationImage,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Text(
                          place.location.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ))
                  ],
                ))
          ],
        ));
  }
}
