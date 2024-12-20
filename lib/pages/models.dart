import 'package:e_commerce/pages/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String prix; // Gardez cela comme String
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.prix, // Prix en String
    required this.quantity,
  });

  // Constructeur pour créer un produit à partir des données Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      imageUrl: data['imageUrl'],
      name: data['name'] ?? '', // Default to empty string if 'name' is null
      description: data['description'] ??
          '', // Default to empty string if 'description' is null
      prix: data['prix'] ?? '0.0', // Gardez le prix en tant que String
      quantity: data['quantity'] ?? 0, // Default to 0 if 'quantity' is null
    );
  }
}

class productDetail {
  final String id; // ID of the meal
  final String name; // Name of the meal
  final String prix; // Price of the meal
  final String description; // Description of the meal

  final String imageUrl; // Availability of the meal

  final String userComment; // ID of the chef

  productDetail({
    required this.id,
    required this.name,
    required this.prix,
    required this.description,
    required this.imageUrl,
    required this.userComment,
  });

// Constructeur pour créer un produit à partir des données Firestore
  factory productDetail.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return productDetail(
      id: doc.id,
      imageUrl: '',
      userComment: '',
      name: data['name'] ?? '', // Default to empty string if 'name' is null
      description: data['description'] ??
          '', // Default to empty string if 'description' is null
      prix: (data['prix'] ?? 0.0) is String
          ? double.tryParse(data['prix']) ?? 0.0
          : data['prix'] ?? 0.0, // Parse 'prix' safely
      //quantity: data['quantity'] ?? 0, // Default to 0 if 'quantity' is null
    );
  }
}
