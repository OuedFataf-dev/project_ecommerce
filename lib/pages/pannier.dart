import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Services/provider.dart'; // Import du PanierProvider
import 'models.dart'; // Import du modèle Product

class PanierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final panierProvider = Provider.of<PanierProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Mon Panier"),
      ),
      body: panierProvider.panier.isEmpty
          ? Center(child: Text("Votre panier est vide"))
          : ListView.builder(
              itemCount: panierProvider.panier.length,
              itemBuilder: (context, index) {
                final product = panierProvider.panier[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        // Image ou une autre illustration
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            //color: Colors.grey[200],
                            height: 80,
                            width: 80,
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit
                                  .cover, // Vous pouvez ajuster cela en fonction de la façon dont vous voulez que l'image soit redimensionnée
                              width: 100, // Largeur de l'image
                              height: 100, // Hauteur de l'image
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.description,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Prix: \$${product.prix}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.orange),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Réduire la quantité
                                          if (product.quantity > 1) {
                                            panierProvider.addProduct(Product(
                                              id: product.id,
                                              name: product.name,
                                              imageUrl: product.imageUrl,
                                              prix: product.prix,
                                              description: product.description,
                                              quantity: -1,
                                            ));
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            panierProvider.removeProduct(product.id);
                            Fluttertoast.showToast(
                              msg: "${product.name} a été supprimé du panier",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Action de paiement ou de confirmation
                Fluttertoast.showToast(
                  msg: "Paiement en cours...",
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("Valider", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
