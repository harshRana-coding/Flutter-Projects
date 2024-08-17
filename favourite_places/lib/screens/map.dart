import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key, required this.location});
  final PlaceLocation location;
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Preview'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              LatLng(widget.location.lantitude, widget.location.longitude),
          initialZoom: 17,
          interactionOptions:
              const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
        ),
        children: [
          openMapTileLayer,
          MarkerLayer(
            markers: [
              Marker(
                  point: LatLng(
                      widget.location.lantitude, widget.location.longitude),
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ))
            ],
          )
        ],
      ),
    );
  }
}

TileLayer get openMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
