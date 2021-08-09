import 'dart:async';

import 'package:fastdeliveryapp/src/resources/google_maps_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ClientLocationScreen extends StatefulWidget {
  final double lat, lang;

  const ClientLocationScreen({Key key, this.lat, this.lang}) : super(key: key);
  @override
  _ClientLocationScreenState createState() => _ClientLocationScreenState();
}

class _ClientLocationScreenState extends State<ClientLocationScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  LatLng _center;
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  getLocation() async {
    var location = new Location();
    location.onLocationChanged.listen((currentLocation) {
      this.setState(
        () {
          _center = LatLng(currentLocation.latitude, currentLocation.longitude);
        },
      );
    });
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_center.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }

  void sendRequest() async {
    LatLng destination = LatLng(widget.lat, widget.lang);
    print("Center: $_center");
    print("Destination: $destination");
    String route =
        await _googleMapsServices.getRouteCoordinates(_center, destination);
    createRoute(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          GoogleMap(
            polylines: _polyLines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: MarkerId("121"),
                position: LatLng(widget.lat, widget.lang),
                icon: BitmapDescriptor.defaultMarker,
              )
            },
          ),
          RawMaterialButton(
            onPressed: () {
              sendRequest();
            },
            child: Text("Get Routes"),
            fillColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
