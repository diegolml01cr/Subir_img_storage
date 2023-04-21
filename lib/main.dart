import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_storage/subir.dart';

// La app esta diseña para ser ejecutada desde el celular

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  String _imageUrl = '';

  // Método para cargar un archivo en Firebase Storage
  Future<void> _uploadFile(File file) async {
    try {
      // Nombre del archivo a guardar en Firebase Storage
      String fileName = 'example.jpg';
      Reference storageReference = _storage.ref().child(fileName);

      // Cargar el archivo a Firebase Storage
      await storageReference.putFile(file);

      // Obtener la URL de descarga del archivo
      String downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (error) {
      print('Error al cargar el archivo: $error');
    }
  }

  // Método para descargar un archivo de Firebase Storage
  Future<void> _downloadFile() async {
    try {
      // Nombre del archivo a descargar
      String fileName = 'example.jpg';
      Reference storageReference = _storage.ref().child(fileName);

      // Descargar el archivo de Firebase Storage
      File file = File(await storageReference.getDownloadURL());
      print('Archivo descargado en: ${file.path}');
    } catch (error) {
      print('Error al descargar el archivo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Mostrar el diálogo de selección de archivo
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                if (result != null) {
                  File file = File(result.files.single.path!);
                  await _uploadFile(file);
                }
              },
              child: Text('Cargar archivo'),
            ),
          ],
        ),
      ),
    );
  }
}
