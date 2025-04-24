import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../extensions/color_extensions.dart';

class Category extends Equatable {
  final String categoryId;
  final String name;
  final Color color;

  const Category({
    required this.categoryId,
    required this.name,
    required this.color,
  });

  factory Category.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final String colorString = data['color'];

    return Category(
      categoryId: doc.id,
      name: data['name'],
      color: colorString.toColor(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.toHex(includeAlpha: false),
    };
  }

  Category copyWith({
    String? categoryId,
    String? name,
    Color? color,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [categoryId, name, color];
}