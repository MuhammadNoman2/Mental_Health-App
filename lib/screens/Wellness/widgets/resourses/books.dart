import 'package:flutter/material.dart';
class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {"title": "The Power of Now", "author": "Eckhart Tolle"},
      {"title": "Atomic Habits", "author": "James Clear"},
      {"title": "Feeling Good", "author": "David D. Burns"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Self-Help Books"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 15),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              book["title"]!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "By ${book["author"]!}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: const Icon(Icons.bookmark, color: Colors.orange),
          );


        },
      ),
    );
  }
}