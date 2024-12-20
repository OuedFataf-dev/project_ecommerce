import 'package:e_commerce/pages/authentification/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddProduct.dart';
import 'DetaillProduct.dart';

class HomePage extends StatefulWidget {
  final List<Product> product;
  const HomePage({super.key, required this.product});
  // Accepter une liste de Meals

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    // Écoute des changements dans le TextField
    searchController.addListener(() {
      setState(() {
        searchTerm = searchController.text
            .toLowerCase(); // Mettre à jour le terme de recherche
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
          ),
          // Champ de recherche
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Icon(Icons.logout),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: searchController, // Utiliser le controller
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'fait vos recherche ici ',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Addtask()),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Aucune tâche"));
                }

                // Filtrer les tâches en fonction du terme de recherche
                final filteredTasks = snapshot.data!.docs.where((doc) {
                  final name = doc['name'] ?? ''; // Obtenir le nom de la tâche
                  return name.toLowerCase().contains(
                      searchTerm); // Vérifier si le nom contient le terme de recherche
                }).toList();

                // Trier les tâches : celles qui correspondent exactement au terme en premier
                filteredTasks.sort((a, b) {
                  final nameA = a['name']?.toLowerCase() ?? '';
                  final nameB = b['name']?.toLowerCase() ?? '';

                  // Vérifier si nameA ou nameB correspond exactement au terme de recherche
                  final aMatches = nameA == searchTerm;
                  final bMatches = nameB == searchTerm;

                  if (aMatches && !bMatches) {
                    return -1; // a vient avant b
                  } else if (!aMatches && bMatches) {
                    return 1; // b vient avant a
                  } else {
                    return nameA.compareTo(
                        nameB); // Sinon, trier par ordre alphabétique
                  }
                });

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final doc = filteredTasks[index];
                    final name = doc['name'] ?? 'Nom par défaut';
                    final prix =
                        doc['prix'] ?? '0€'; // S'assurer que c'est une chaîne
                    final description =
                        doc['description'] ?? 'Aucune description';
                    final imageUrl = doc['imageUrl'] ?? 'Aucune description';
                    // final quantity = doc['quantity'] ?? 'quantity';

                    return Product(
                      id: doc.id, // Passer l'ID du document ici
                      name: name,
                      imageUrl: imageUrl,
                      prix: prix, // Le prix est une chaîne
                      description: description,
                      //  quantity: quantity,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product extends StatelessWidget {
  final String id; // Ajout de l'ID du document
  final String name;
  final String imageUrl;

  final String prix;
  final String description;
  // final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.prix,
    required this.description,
    // required this.quantity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetaillProduct(ProductId: id, quantity: 1)));
      },
      child: Container(
        width: 300,
        height: 180,

        margin: EdgeInsets.symmetric(vertical: 8 //horizontal: 8
            ),
        decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
              image: NetworkImage(
                imageUrl,
              ), // Utilisation de l'image en arrière-plan
              fit: BoxFit.cover

              // Ajuste l'image pour couvrir le Container
              ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              // color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        // height: 200,

        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 400),
                  child: Text(
                    prix,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              SizedBox(height: 15.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
