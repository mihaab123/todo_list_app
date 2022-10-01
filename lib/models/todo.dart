// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Todo {
  int id;
  String title;
  String description;
  int todoDate;
  String category;
  int isFinished;
  String repeat;
  Todo({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.todoDate,
    @required this.category,
    @required this.isFinished,
    @required this.repeat,
  });

  Todo copyWith({
    int id,
    String title,
    String description,
    int todoDate,
    String category,
    int isFinished,
    String repeat,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      todoDate: todoDate ?? this.todoDate,
      category: category ?? this.category,
      isFinished: isFinished ?? this.isFinished,
      repeat: repeat ?? this.repeat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'todoDate': todoDate,
      'category': category,
      'isFinished': isFinished,
      'repeat': repeat,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      todoDate: map['todoDate'] as int,
      category: map['category'] as String,
      isFinished: map['isFinished'] as int,
      repeat: map['repeat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, todoDate: $todoDate, category: $category, isFinished: $isFinished, repeat: $repeat)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.todoDate == todoDate &&
        other.category == category &&
        other.isFinished == isFinished &&
        other.repeat == repeat;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        todoDate.hashCode ^
        category.hashCode ^
        isFinished.hashCode ^
        repeat.hashCode;
  }
}
