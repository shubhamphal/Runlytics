import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AzureMapCurrentPosition extends StatefulWidget {
  @override
  _AzureMapCurrentPositionState createState() =>
      _AzureMapCurrentPositionState();
}

class _AzureMapCurrentPositionState extends State<AzureMapCurrentPosition> {
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);

  //default position
  LatLng currentpositon = new LatLng(15.482137, 73.809141);

  Future<void> getcurrentpositon() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentpositon = new LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    getcurrentpositon();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 400,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                options: new MapOptions(
                  center: currentpositon,
                  zoom: 12.0,
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                    "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=basic&style=dark&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",
                    additionalOptions: {
                      'subscriptionKey':
                      'Add Your Key Here'
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 30.0,
                        height: 30.0,
                        point: currentpositon,
                        builder: (ctx) => new Container(
                          child: new Icon(
                            Icons.my_location,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
