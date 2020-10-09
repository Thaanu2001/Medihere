import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medihere/screens/prescription_upload_screen.dart';
import 'package:medihere/transitions/sliding_transition.dart';
import 'package:medihere/widgets/scroll_glow_disabler.dart';

LocationData currentLocation;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PickedFile imageFile;
  File croppedImage;

  @override
  bool get wantKeepAlive => true;

  _openGallery(BuildContext context, String pharmacyName, String pharmacyPlace,
      String pharmacyCode) async {
    //* Get prescription using gallery --------------------------------------------------------------------------------
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      print('Hereeeeeeeeee - ${imageFile.path}');
    });
    Navigator.of(context).pop();
    _cropImage(context, pharmacyName, pharmacyPlace, pharmacyCode);
  }

  _openCamera(BuildContext context, String pharmacyName, String pharmacyPlace,
      String pharmacyCode) async {
    //* Get prescription using camera --------------------------------------------------------------------------------
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      print('Hereeeeeeeeee - ${imageFile.path}');
    });
    Navigator.of(context).pop();
    _cropImage(context, pharmacyName, pharmacyPlace, pharmacyCode);
  }

  _cropImage(BuildContext context, String pharmacyName, String pharmacyPlace,
      String pharmacyCode) async {
    //* Crop the imported image -----------------------------------------------------------------------------------
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      androidUiSettings: AndroidUiSettings(
        activeControlsWidgetColor: Color(0xff3b53e5),
      ),
    );
    setState(() {
      if (cropped != null) {
        croppedImage = cropped ?? imageFile.path;
      }
    });

    if (croppedImage != null) {
      Route route = SlidingTransition(
        widget: PrescriptionUploadScreen(
          file: croppedImage,
          pharmacyName: pharmacyName,
          pharmacyPlace: pharmacyPlace,
          pharmacyCode: pharmacyCode,
        ),
      );
      Navigator.push(_scaffoldKey.currentContext, route);
    }
  }

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
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: [
            Stack(
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
                  padding: EdgeInsets.fromLTRB(30, 75, 0, 10),
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
                Container(
                  //* Refresh button --------------------------------------------------------------------------------
                  padding: EdgeInsets.fromLTRB(0, 55, 45, 10),
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: Color(0xff3b53e5),
                    ),
                    onTap: () {
                      //currentLocation = null;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder(
              //* Load pharmacy list ---------------------------------------------------------------------------------
              future: getLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(child: getLocationList(context));
                } else {
                  return Container(
                    padding: EdgeInsets.only(top: 15),
                    child: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 4.0,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  getLocationList(context) {
    //* get list of pharmacies closer to current location -----------------------------------------------------------
    final geo = Geoflutterfire();
    final _firestore = FirebaseFirestore.instance;

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
          return ScrollGlowDisabler(
            child: ListView(
              padding: EdgeInsets.zero,
              children: snapshot.data.map((snapshot) {
                return Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: InkWell(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: Text(snapshot['name'].toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Text(snapshot['place'].toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      importChoiceDialog(
                          context,
                          snapshot['name'].toString(),
                          snapshot['place'].toString(),
                          snapshot['place'].toString());
                    },
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 10),
                          color: Color(0xff000000).withOpacity(.1),
                          spreadRadius: -9)
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 4.0,
              ),
            ),
          );
        }
      },
    );
  }

  getLocation() async {
    print('$currentLocation');
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

  importChoiceDialog(BuildContext context, String pharmacyName,
      String pharmacyPlace, String pharmacyCode) {
    //* Import choice dialog ---------------------------------------------------------------------------------
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  child: Text('Upload the prescription from,',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 8),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _openCamera(
                        context, pharmacyName, pharmacyPlace, pharmacyCode);
                  },
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
                    child: Row(
                      children: [
                        Icon(Icons.photo),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _openGallery(
                        context, pharmacyName, pharmacyPlace, pharmacyCode);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
