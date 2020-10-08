import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData currentLocation;

  @override
  void initState() {
    //getLocation();
    //getLocationList();
    //print(getLocationList() as String);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              //* Topic Text ---------------------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 45, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Pharmacies near you',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Location Change button ---------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 2, 0, 0),
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Text(
                  'Change your location',
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 15,
                      color: Color(0xff3b53e5),
                      fontWeight: FontWeight.w400),
                ),
                onTap: () {},
              ),
            ),
            FutureBuilder(
              future: getLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(height: 300, child: getLocationList());
                } else {
                  return Text('Loading...');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  getLocationList() {
    //* get list of pharmacies closer to current location -----------------------------------------------------------

    final geo = Geoflutterfire();
    final _firestore = FirebaseFirestore.instance;

    GeoFirePoint myLocation =
        geo.point(latitude: 6.851633, longitude: 79.920072);

    // _firestore
    //     .collection('pharmacies')
    //     .add({'name': 'pharmacy 4', 'location': myLocation.data});

    //* Create a geoFirePoint
    GeoFirePoint center = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);

    //* get the collection reference or query
    var collectionReference = _firestore.collection('pharmacies');

    double radius = 5; //* 5km radius
    String field = 'location';

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: geo.collection(collectionRef: collectionReference).within(
          center: center, radius: radius, field: field, strictMode: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data.map((snapshot) {
            return Card(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: Text(snapshot['name'].toString(),
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ),
            );
          }).toList());
        } else {
          return Text('Loading...');
        }
      },
    );
  }

  getLocation() async {
    //* Get user's current location ----------------------------------------------------------------------------
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    currentLocation = _locationData;
    return '';
  }
}
