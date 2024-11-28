import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/provider.dart';
import 'models.dart'; // Import Product from models.dart
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetaillProduct extends StatefulWidget {
  final String ProductId;
  final int quantity;

  const DetaillProduct(
      {super.key, required this.ProductId, required this.quantity});

  @override
  State<DetaillProduct> createState() => _DetaillProductState();
}

class _DetaillProductState extends State<DetaillProduct> {
  int selectedQuantity = 1;
  bool isLoading = true;
  Product? productDetail;

  // Méthode pour récupérer les détails du produit depuis Firestore
  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(
              'tasks') // Assurez-vous que la collection Firestore s'appelle 'tasks'
          .doc(widget.ProductId) // Utilisation de l'ID du produit
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          productDetail =
              Product.fromFirestore(docSnapshot); // Correct Product class
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails(); // Récupération des détails au moment du chargement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CupertinoIcons.chevron_back, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Détail",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 25)),
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(color: Colors.white),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (productDetail != null) ...[
                          SizedBox(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 55),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Text('SALUT')),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    height: 160,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              productDetail!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              productDetail!.description,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 30),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 30),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 30),
                                Icon(Icons.star_half,
                                    color: Colors.yellow, size: 30),
                                Icon(Icons.star_border,
                                    color: Colors.yellow, size: 30),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prix: ${productDetail!.prix}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedQuantity++;
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      Text('$selectedQuantity'),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selectedQuantity > 1) {
                                              selectedQuantity--;
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Créer un nouveau produit à partir de celui récupéré
                                  Product nouveauProduct = Product(
                                      id: productDetail!.id,
                                      name: productDetail!.name,
                                      prix: productDetail!.prix,
                                      description: productDetail!.description,
                                      quantity: productDetail!.quantity);

                                  // Ajouter le produit au panier via le PanierProvider
                                  final ProductPanier =
                                      Provider.of<PanierProvider>(context,
                                              listen: false)
                                          .addProduct(nouveauProduct);

                                  // Affichage d'un Snackbar pour notifier l'utilisateur
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${productDetail!.name} a été ajouté au panier."),
                                      duration: Duration(
                                          seconds:
                                              2), // Durée d'affichage du message
                                    ),
                                  );
                                  //print('Produit ajouté au panier: ${productDetail!.name}, Quantité: $selectedQuantity');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text(
                                  "Ajouter au panier",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
