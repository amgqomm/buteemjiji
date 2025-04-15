import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String categoryId;
  final String name;
  final Color color;

  Category({
    required this.categoryId,
    required this.name,
    required this.color,
  });

  factory Category.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Category(
      categoryId: doc.id,
      name: data['name'] ?? 'Uncategorized',
      color: Color(data['color'] ?? 0xFF9E9E9E),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value,
    };
  }
}