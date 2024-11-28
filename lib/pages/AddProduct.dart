import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home_page.dart';

class Addtask extends StatefulWidget {
  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prixController = TextEditingController();

  Future<void> ajoutertasker() async {
    final String name = nameController.text;
    final String prix = prixController.text;
    final String description = descriptionController.text;

    // Crée une référence à la collection "tasks"
    final collectionRef = FirebaseFirestore.instance.collection('tasks');

    // Crée un nouvel identifiant de document pour la tâche
    final taskId = collectionRef.doc().id;

    // Crée un document avec les données de la tâche
    await collectionRef.doc(taskId).set({
      'name': name,
      'prix': prix,
      'description': description,
      'userId': taskId,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const HomePage(
                product: [],
              )),
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centre le contenu
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
                  Center(
                    child: ElevatedButton(
                      child: Text("Ajouter"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ajoutertasker();
                        }
                      },
                    ),
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
