import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medihere/buttons/back_button.dart';
import 'package:medihere/sharedData.dart';
import 'package:medihere/widgets/scroll_glow_disabler.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  final File file;
  final String pharmacyName, pharmacyPlace, pharmacyCode;

  PrescriptionUploadScreen(
      {Key key,
      this.file,
      @required this.pharmacyName,
      @required this.pharmacyPlace,
      @required this.pharmacyCode})
      : super(key: key);

  createState() => _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://medihere-f0428.appspot.com/');

  final noteText = TextEditingController();

  StorageUploadTask _uploadTask;
  double image1Opacity = 0.5;
  double image2Opacity = 0.5;
  double image3Opacity = 0.5;

  PickedFile imageFile;
  File croppedImage1;
  File croppedImage2;
  File croppedImage3;

  bool isImage1Available = false;
  bool isImage2Available = false;
  bool isImage3Available = false;
  bool firstImageRemoved = false;

  String filePath1;
  String filePath2;
  String filePath3;

  bool error = false;

  _openGallery(BuildContext context) async {
    //* Get prescription using gallery --------------------------------------------------------------------------------
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
    _cropImage(context);
  }

  _openCamera(BuildContext context) async {
    //* Get prescription using camera --------------------------------------------------------------------------------
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
    _cropImage(context);
  }

  _cropImage(BuildContext context) async {
    //* Crop the imported image -----------------------------------------------------------------------------------
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      androidUiSettings: AndroidUiSettings(
        activeControlsWidgetColor: SharedData.mainColor,
      ),
    );
    setState(() {
      if (cropped != null) {
        if (!isImage1Available) {
          croppedImage1 = cropped ?? imageFile.path;
          image1Opacity = 0.5;
        } else if (!isImage2Available) {
          croppedImage2 = cropped ?? imageFile.path;
          image2Opacity = 0.5;
        } else {
          croppedImage3 = cropped ?? imageFile.path;
          image3Opacity = 0.5;
        }
        _startUpload();
      }
    });
  }

  _startUpload() {
    //* Start uploading image to firestore ------------------------------------------------------------------------
    String filePath =
        'prescriptions/${widget.pharmacyCode}/${DateTime.now()}.png';

    if (isImage1Available || isImage2Available || isImage3Available) {
      print('here');
      _uploadTask = null;
    }

    setState(() {
      if (!isImage1Available) {
        isImage1Available = true;
        if (!firstImageRemoved) {
          _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
        } else {
          _uploadTask = _storage.ref().child(filePath).putFile(croppedImage1);
        }
        filePath1 = filePath;
      } else if (!isImage2Available) {
        isImage2Available = true;
        _uploadTask = _storage.ref().child(filePath).putFile(croppedImage2);
        filePath2 = filePath;
      } else {
        _uploadTask = _storage.ref().child(filePath).putFile(croppedImage3);
        filePath3 = filePath;
        isImage3Available = true;
      }
      print('$isImage1Available, $isImage2Available, $isImage3Available');
    });
  }

  _uploadImageData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance.collection('prescriptions').doc().set({
      'user_contact': '${auth.currentUser.phoneNumber.replaceAll('+94', '0')}',
      'user_name': '${auth.currentUser.displayName}',
      'pharmacy_name': '${widget.pharmacyName}',
      'pharmacy_code': '${widget.pharmacyCode}',
      'image_1': filePath1,
      'image_2': (isImage2Available) ? filePath2 : '',
      'image_3': (isImage3Available) ? filePath3 : '',
      'status': 0,
      'time': DateTime.now(),
      'note': noteText.text
    });
  }

  @override
  void initState() {
    _startUpload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          if (_uploadTask.isComplete) {
            image1Opacity = 1;
            image2Opacity = 1;
            image3Opacity = 1;
          }

          return Column(
            children: [
              Container(
                //* Back Button ------------------------------------------------------------------------------------
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 40, left: 20),
                child: BackActionButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (isImage1Available) {
                      await _storage.ref().child(filePath1).delete();
                    }
                    if (isImage2Available) {
                      await _storage.ref().child(filePath2).delete();
                    }
                    if (isImage3Available) {
                      await _storage.ref().child(filePath3).delete();
                    }
                  },
                ),
              ),
              Container(
                //* Pharmacy name Text ---------------------------------------------------------------------------------------------
                padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.pharmacyName,
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                //* Pharmacy place Text ---------------------------------------------------------------------------------------------
                padding: EdgeInsets.fromLTRB(30, 4, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.pharmacyPlace,
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: ScrollGlowDisabler(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          //* Image Uploading Card ---------------------------------------------------------------------------------------
                          margin: EdgeInsets.fromLTRB(30, 10, 30, 20),
                          child: Card(
                            color: Color(0xff939393),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            elevation: 0,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                (!(isImage1Available &&
                                            isImage2Available &&
                                            isImage3Available) &&
                                        _uploadTask.isComplete)
                                    ? Container(
                                        //* Upload more button --------------------------------------------------------------------
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        color: Color(0xffececec),
                                        height: 124,
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.3) -
                                                25,
                                        child: InkWell(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(Icons.add_a_photo_outlined),
                                              Text(
                                                'Add Image',
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            importChoiceDialog(context);
                                            print(isImage2Available);
                                            print(isImage3Available);
                                          },
                                        ),
                                      )
                                    : Container(),
                                (!(isImage1Available &&
                                            isImage2Available &&
                                            isImage3Available) &&
                                        _uploadTask.isComplete)
                                    ? SizedBox(width: 10)
                                    : Container(),
                                (isImage3Available)
                                    ? Container(
                                        //* Uploaded image preview 3 ------------------------------------------------------
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.3) -
                                                25,
                                        color: Colors.white,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Opacity(
                                              opacity: image3Opacity,
                                              child: Image.file(
                                                croppedImage3,
                                                // width: 90,
                                                height: 120,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            (image3Opacity == 1)
                                                //* Delete button for image 3 ------------------------------------------------------
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin: EdgeInsets.only(
                                                        top: 5, right: 5),
                                                    child: InkResponse(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        if (isImage3Available) {
                                                          setState(() {
                                                            isImage3Available =
                                                                false;
                                                          });
                                                          await _storage
                                                              .ref()
                                                              .child(filePath3)
                                                              .delete();
                                                          print('Done');
                                                          print('image 3');
                                                        }
                                                      },
                                                      child: new Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            new BoxDecoration(
                                                          color:
                                                              Color(0xbb3b53e5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: new Icon(
                                                            Icons.close,
                                                            color: Color(
                                                                0xffffffff),
                                                            size: 15.0),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            (image3Opacity == 0.5)
                                                //* Progress indicator for image 2 ------------------------------------------------------
                                                ? Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: null,
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (isImage3Available)
                                    ? SizedBox(width: 10)
                                    : Container(),
                                (isImage2Available)
                                    ? Container(
                                        //* Uploaded image preview 2 ------------------------------------------------------
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.3) -
                                                25,
                                        color: Colors.white,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Opacity(
                                              opacity: image2Opacity,
                                              child: Image.file(
                                                croppedImage2,
                                                // width: 90,
                                                height: 120,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            (image2Opacity == 1)
                                                //* Delete button for image 2 ------------------------------------------------------
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin: EdgeInsets.only(
                                                        top: 5, right: 5),
                                                    child: InkResponse(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        if (isImage2Available) {
                                                          setState(() {
                                                            isImage2Available =
                                                                false;
                                                          });
                                                          await _storage
                                                              .ref()
                                                              .child(filePath2)
                                                              .delete();
                                                          print('Done');
                                                          print('image 2');
                                                        }
                                                      },
                                                      child: new Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            new BoxDecoration(
                                                          color:
                                                              Color(0xbb3b53e5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: new Icon(
                                                            Icons.close,
                                                            color: Color(
                                                                0xffffffff),
                                                            size: 15.0),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            (image2Opacity == 0.5)
                                                //* Progress indicator for image 2 ------------------------------------------------------
                                                ? Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: null,
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (isImage2Available)
                                    ? SizedBox(width: 10)
                                    : Container(),
                                (isImage1Available)
                                    ? Container(
                                        //* Uploaded image 1 preview ------------------------------------------------------
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.3) -
                                                25,
                                        color: Colors.white,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Opacity(
                                              opacity: image1Opacity,
                                              child: Image.file(
                                                (!firstImageRemoved)
                                                    ? widget.file
                                                    : croppedImage1,
                                                // width: 90,
                                                height: 120,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            (image1Opacity == 1)
                                                //* Delete button for image 1 ------------------------------------------------------
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin: EdgeInsets.only(
                                                        top: 5, right: 5),
                                                    child: InkResponse(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        if (isImage1Available) {
                                                          setState(() {
                                                            isImage1Available =
                                                                false;
                                                            firstImageRemoved =
                                                                true;
                                                          });
                                                          await _storage
                                                              .ref()
                                                              .child(filePath1)
                                                              .delete();
                                                          print('Done');
                                                          print('image 1');
                                                        }
                                                      },
                                                      child: new Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            new BoxDecoration(
                                                          color:
                                                              Color(0xbb3b53e5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: new Icon(
                                                            Icons.close,
                                                            color: Color(
                                                                0xffffffff),
                                                            size: 15.0),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            (image1Opacity == 0.5)
                                                ? Positioned.fill(
                                                    //* Progress indicator for image 1 ------------------------------------------------------
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: null,
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
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
                        ),
                        Container(
                          //* Add a note Text ---------------------------------------------------------------------------------------------
                          padding: EdgeInsets.fromLTRB(30, 4, 0, 0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Add a note',
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          //* Add a note TextField ------------------------------------------------------------------------
                          padding: EdgeInsets.fromLTRB(30, 6, 30, 0),
                          child: ScrollGlowDisabler(
                            child: TextField(
                              controller: noteText,
                              // keyboardType: TextInputType.number,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                hintText: 'Add a note...',
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.red,
                                counter: SizedBox.shrink(),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: SharedData.mainColor, width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: SharedData.mainColor, width: 2),
                                ),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          // decoration: BoxDecoration(
                          //   boxShadow: [
                          //     BoxShadow(
                          //         blurRadius: 6,
                          //         offset: Offset(0, 20),
                          //         color: Color(0xff000000).withOpacity(.1),
                          //         spreadRadius: -20)
                          //   ],
                          // ),
                        ),
                        (error)
                            ? Container(
                                //* Error message Text -------------------------------------------------------------------------------
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Please upload your prescription',
                                  style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : Container(),
                        Container(
                          //* Continue Button ----------------------------------------------------------------------------------
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(30, 15, 30, 20),
                          child: RaisedButton(
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                'Send',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                //width: double.infinity,
                              ),
                            ),
                            elevation: 4,
                            highlightColor: SharedData.buttonHighlightColor,
                            color: SharedData.mainColor,
                            padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            onPressed: () {
                              if (isImage1Available) {
                                _uploadImageData();
                              } else {
                                error = true;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  importChoiceDialog(BuildContext context) {
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
                    _openCamera(context);
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
                    _openGallery(context);
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
