import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Esta es otra version de app para subir imagenes al storage

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({ Key? key }) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _image;
  String? _imageUrl;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final reference = FirebaseStorage.instance.ref().child('images/$fileName');
    final uploadTask = reference.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: _image == null ? Text('No image selected.') : Image.file(_image!),
        ),
        ElevatedButton(
          onPressed: pickImage,
          child: Text('Select Image'),
        ),
        ElevatedButton(
          onPressed: uploadImage,
          child: Text('Upload Image'),
        ),
        SizedBox(
          height: 20,
        ),
        _imageUrl == null ? Container() : Image.network(_imageUrl!),
      ],
    );
  }
}