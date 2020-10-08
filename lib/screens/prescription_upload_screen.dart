import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  final File file;

  PrescriptionUploadScreen({Key key, this.file}) : super(key: key);

  createState() => _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://medihere-f0428.appspot.com/');

  StorageUploadTask _uploadTask;

  _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return Scaffold(
          body: StreamBuilder<StorageTaskEvent>(
              stream: _uploadTask.events,
              builder: (context, snapshot) {
                var event = snapshot?.data?.snapshot;

                double progressPercent = event != null
                    ? event.bytesTransferred / event.totalByteCount
                    : 0;

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_uploadTask.isComplete)
                        Text('🎉🎉🎉',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                height: 2,
                                fontSize: 30)),
                      if (_uploadTask.isPaused)
                        FlatButton(
                          child: Icon(Icons.play_arrow, size: 50),
                          onPressed: _uploadTask.resume,
                        ),
                      if (_uploadTask.isInProgress)
                        FlatButton(
                          child: Icon(Icons.pause, size: 50),
                          onPressed: _uploadTask.pause,
                        ),
                      LinearProgressIndicator(value: progressPercent),
                      Text(
                        '${(progressPercent * 100).toStringAsFixed(2)} % ',
                        style: TextStyle(fontSize: 50),
                      ),
                    ]);
              }));
    } else {
      return Scaffold(
          body: FlatButton.icon(
              color: Colors.blue,
              label: Text('Upload to Firebase'),
              icon: Icon(Icons.cloud_upload),
              onPressed: _startUpload));
    }
  }
}
