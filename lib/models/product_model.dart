import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String fullName;
  final String categoryId;
  final String description;
  final double price;
  final List<String>? colors;
  final String imageUrl;
  final Color backgroundColor;

  Product({
    required this.id,
    required this.name,
    required this.fullName,
    required this.categoryId,
    this.colors,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
  });
}
