import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  XFile? file;
  ImagePicker _picker = ImagePicker();
  bool _loading = false;
  List<dynamic>? _output;
  String? _diseaseName;
  double? _accuracy;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Detect',
            style: TextStyle(color: Colors.green),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () async {
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        file = photo;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_rounded, color: Colors.white),
                        SizedBox(width: 15),
                        Text(
                          'OPEN GALLERY',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        file = photo;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.white),
                        SizedBox(width: 15),
                        Text(
                          'START CAMERA',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: file == null
                      ? Container(
                          height: 200,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 240, 240),
                            border: Border.all(
                                color: Color.fromARGB(255, 186, 186, 186)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: Text(
                            'Image Not picked',
                            style: TextStyle(fontSize: 20),
                          )),
                        )
                      : Container(
                          height: 200,
                          width: 350,
                          child: Image.file(File(file!.path), fit: BoxFit.cover),
                        ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      detectDisease();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: Text(
                      'DETECT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (_diseaseName != null && _accuracy != null) // Display disease name and accuracy if available
                  Column(
                    children: [
                      Text('Disease: $_diseaseName'),
                     /* Text('Accuracy: ${(_accuracy! * 100).toStringAsFixed(2)}%'),*/
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
            height: 40,
            width: 200,
            
            child: ElevatedButton(onPressed: (){
              fetchPrecautionsFromFirestore(_diseaseName!); // Fetch precautions when button is pressed
            }, 
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 102, 155, 234)),
              ),
            child: Text('PRECAUTIONS',style: TextStyle(color: Colors.white),)
            
            ),
          ),
              ],
            ),
    );
  }


  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/label.txt',
    );
  }

  Future<void> detectDisease() async {
    if (file == null) return;

    setState(() {
      _loading = true;
    });

    var output = await Tflite.runModelOnImage(
      path: file!.path,
      numResults: 10, // Adjusted to match code 2
      threshold: 0.05, // Adjusted to match code 2
      imageMean: 127.5, // Ensure preprocessing matches code 2 if needed
      imageStd: 127.5, // Ensure preprocessing matches code 2 if needed
    );

    setState(() {
      _loading = false;
      _output = output;
    });

    if (_output != null && _output!.isNotEmpty) {
      _diseaseName = _output![0]['label'];
      _accuracy = _output![0]['confidence'];
    }
  }

  Future<void> fetchPrecautionsFromFirestore(String diseaseName) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('precautions')
          .doc(diseaseName)
          .get();
      if (snapshot.exists) {
        List<String> precautions = List<String>.from(snapshot['precautions']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PrecautionDialog(precautions: precautions);
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Precautions'),
              content: Text('Precautions not available for $_diseaseName'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching precautions: $e');
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}

class PrecautionDialog extends StatelessWidget {
  final List<String> precautions;

  const PrecautionDialog({Key? key, required this.precautions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Precautions'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String precaution in precautions) Text(precaution),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
