import 'package:e_commerce/pages/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double prix; // Change to double if necessary
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.prix,
    required this.quantity,
  });

  // Constructeur pour créer un produit à partir des données Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'] ?? '', // Default to empty string if 'name' is null
      description: data['description'] ??
          '', // Default to empty string if 'description' is null
      prix: (data['prix'] ?? 0.0) is String
          ? double.tryParse(data['prix']) ?? 0.0
          : data['prix'] ?? 0.0, // Parse 'prix' safely
      quantity: data['quantity'] ?? 0, // Default to 0 if 'quantity' is null
    );
  }
}

class productDetail {
  final String id; // ID of the meal
  final String name; // Name of the meal
  final double price; // Price of the meal
  final String description; // Description of the meal

  final String imagePath; // Availability of the meal

  final String userComment; // ID of the chef

  productDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.userComment,
  });
}
