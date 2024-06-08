import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveData {
  static List<Book> books = [];
  static final _random = Random();

  static Future<void> addBook(String name, String category) async {
    final db = FirebaseFirestore.instance;
    final id = (_random.nextInt(1000) + 1).toString();
    await db.collection('books').doc(id).set({
      'id': id,
      'name': name,
      'category': category,
    });
    books = await getBooks();
  }

  static Future<void> deleteBook(String id) async {
    final db = FirebaseFirestore.instance;
    await db.collection('books').doc(id).delete();
    books = await getBooks(); // Cập nhật lại danh sách sau khi xóa
  }

  static Future<List<Book>> getBooks() async {
    final db = FirebaseFirestore.instance;
    final results = await db.collection('books').get();
    if (results != null) {
      return results.docs.map((item) => Book.fromMap(item.data())).toList();
    } else {
      return [];
    }
  }

  static Future<void> updateBook(String id, String newName, String newCategory) async {
    final db = FirebaseFirestore.instance;
    await db.collection('books').doc(id).update({
      'name': newName,
      'category': newCategory,
    });
    books = await getBooks(); // Cập nhật lại danh sách sau khi cập nhật
  }
}

class Book {
  final String id;
  final String name;
  final String category;

  Book({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
    );
  }
}
