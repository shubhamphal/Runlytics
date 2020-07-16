import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class AzureMapRoute extends StatefulWidget {
  AzureMapRoute(this.positions);

  List<Position> positions;

  @override
  _AzureMapRouteState createState() => _AzureMapRouteState(positions);
}

class _AzureMapRouteState extends State<AzureMapRoute> {
  _AzureMapRouteState(this.positions);

  List<Position> positions;
  int index1;
  int index2;
  LatLng zoom_center;

  List<LatLng> polypoints;

  @override
  void initState() {
    int pos_length = positions.length;

    if (pos_length > 3) {
      index1 = (pos_length / 3).floor();
      index2 = (pos_length * 2 / 3).floor();
      double latitude_index1 = 0;
      double longitude_index1 = 0;
      double latitude_index2 = 0;
      double longitude_index2 = 0;
      double latitude_index3 = 0;
      double longitude_index3 = 0;

      positions.getRange(0, index1).forEach((Position position) {
        latitude_index1 += position.latitude;
      });
      positions.getRange(0, index1).forEach((Position position) {
        longitude_index1 += position.longitude;
      });
      positions.getRange(index1, index2).forEach((Position position) {
        latitude_index2 += position.latitude;
      });
      positions.getRange(index1, index2).forEach((Position position) {
        longitude_index2 += position.longitude;
      });
      positions.getRange(index2, pos_length).forEach((Position position) {
        latitude_index3 += position.latitude;
      });
      positions.getRange(index2, pos_length).forEach((Position position) {
        longitude_index3 += position.longitude;
      });

      latitude_index1 = latitude_index1 / index1;
      longitude_index1 = longitude_index1 / index1;

      latitude_index2 = latitude_index2 / (index2 - index1);
      longitude_index2 = longitude_index2 / (index2 - index1);

      latitude_index3 = latitude_index3 / (pos_length - index2);
      longitude_index3 = longitude_index3 / (pos_length - index2);

      polypoints = [
        new LatLng(positions.first.latitude, positions.first.longitude),
        new LatLng(latitude_index1, longitude_index1),
        new LatLng(latitude_index2, longitude_index2),
        new LatLng(latitude_index3, longitude_index3),
        new LatLng(positions.last.latitude, positions.last.longitude)
      ];
    } else if (pos_length > 0) {
      polypoints = [];
      positions.forEach((Position position) {
        polypoints.add(new LatLng(position.latitude, position.longitude));
      });
      zoom_center = polypoints.last;
    } else {
      polypoints = [
        new LatLng(15.482137, 73.809141),
        new LatLng(15.483137, 73.804141)
      ];
      zoom_center = new LatLng(15.482137, 73.809141);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200,
      width: 400,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          color: Colors.grey[850].withOpacity(0.5)),
      child: Flex(direction: Axis.horizontal, children: [
        Flexible(
            child: FlutterMap(
              options: new MapOptions(
                center: zoom_center,
                zoom: 10.0,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                  "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=basic&style=dark&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",
                  additionalOptions: {
                    'subscriptionKey': 'Add Your Key Here'
                  },
                ),
                new PolylineLayerOptions(polylines: [
                  new Polyline(
                      points: polypoints,
                      strokeWidth: 5.0,
                      isDotted: true,
                      color: Colors.deepOrangeAccent)
                ])
              ],
            )),
      ]),
    );
  }
}
