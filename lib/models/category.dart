// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Category {
  int id;
  String name;
  String description;
  int color;
  Category({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.color,
  });

  Category copyWith({
    int id,
    String name,
    String description,
    int color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'color': color,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      color: map['color'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, color: $color)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode;
  }
}
