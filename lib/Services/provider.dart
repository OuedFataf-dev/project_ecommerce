import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import '../models/product.dart';
import '../pages/models.dart';
// Assurez-vous d'importer la classe Product

class PanierProvider with ChangeNotifier {
  List<Product> _panier = [];

  List<Product> get panier => _panier;

  // Ajouter un produit au panier
  void addProduct(Product product) {
    // Vérifier si le produit est déjà dans le panier
    final existingProductIndex = _panier.indexWhere((p) => p.id == product.id);

    if (existingProductIndex >= 0) {
      // Si le produit existe déjà, on augmente sa quantité
      final existingProduct = _panier[existingProductIndex];
      final updatedProduct = Product(
        id: existingProduct.id,
        name: existingProduct.name,
        prix: existingProduct.prix,
        description: existingProduct.description,
        quantity: existingProduct.quantity +
            product.quantity, // Directly add quantities as integers
      );
      _panier[existingProductIndex] = updatedProduct;
    } else {
      // Si c'est un nouveau produit, on l'ajoute au panier
      _panier.add(product);
    }

    notifyListeners(); // Notifier les widgets qui écoutent cet état
  }

  // Supprimer un produit du panier
  void removeProduct(String productId) {
    _panier.removeWhere((product) => product.id == productId);
    notifyListeners(); // Notifier les widgets qui écoutent cet état
  }

  // Méthode pour vider le panier
  void clearPanier() {
    _panier.clear();
    notifyListeners(); // Notifier les widgets qui écoutent cet état
  }
}
