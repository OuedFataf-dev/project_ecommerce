import 'dart:html' as html; // Use the HTML library for web
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart'; // For file picker
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Addtask extends StatefulWidget {
  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  html.File? imageFile;
  bool isLoading = false;
  bool isFilePickerActive = false;
  String? uploadedImageUrl;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
  }

  // Method to select an image (Updated for Web)
  Future<void> getImage() async {
    if (isFilePickerActive) return;

    setState(() {
      isFilePickerActive = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        // For Web: Use the html.File (blob) from FilePicker
        if (result.files.isNotEmpty) {
          final webFile =
              html.File(result.files.single.bytes!, result.files.single.name);

          setState(() {
            imageFile = webFile;
          });

          Fluttertoast.showToast(
            msg: 'Fichier sélectionné: ${result.files.single.name}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Aucun fichier sélectionné',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Erreur lors de la sélection de fichier: $e');
      Fluttertoast.showToast(
        msg: 'Erreur lors de la sélection de fichier',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isFilePickerActive = false;
      });
    }
  }

  // Upload Image to Firebase Storage (Modified for Web)
  Future<void> uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(
        msg: 'Veuillez sélectionner une image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Téléchargement de l'image dans Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');

    final reader = html.FileReader();
    reader.readAsArrayBuffer(imageFile!);

    reader.onLoadEnd.listen((e) async {
      final Uint8List data = reader.result as Uint8List;

      try {
        final uploadTask = storageRef.putData(data);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        if (imageUrl != null) {
          setState(() {
            uploadedImageUrl = imageUrl;
            imageFile = null;
          });

          Fluttertoast.showToast(
            msg: 'Image téléchargée avec succès',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Erreur lors du téléchargement de l\'image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  // Method to add task
  Future<void> ajoutertasker() async {
    final String name = nameController.text;
    final String prix = prixController.text;
    final String description = descriptionController.text;

    if (uploadedImageUrl == null) {
      Fluttertoast.showToast(
        msg: 'Veuillez d\'abord télécharger une image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final collectionRef = FirebaseFirestore.instance.collection('tasks');
    final taskId = collectionRef.doc().id;

    await collectionRef.doc(taskId).set({
      'name': name,
      'prix': prix,
      'description': description,
      'userId': taskId,
      'imageUrl': uploadedImageUrl, // Add image URL
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(product: []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Nom',
                        labelText: 'Votre nom',
                        errorStyle: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: prixController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        hintText: 'Prix',
                        labelText: 'Votre prix',
                        errorStyle: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                        hintText: 'Description',
                        labelText: 'Description',
                        errorStyle: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isFilePickerActive ? null : getImage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Sélectionner l'image",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Télécharger l'image"),
                    onPressed: uploadImage,
                  ),
                  isLoading ? CircularProgressIndicator() : SizedBox(),
                  ElevatedButton(
                    onPressed: ajoutertasker,
                    child: Text("Ajouter tâche"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
