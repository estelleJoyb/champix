import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets/book_list.dart';

class AuthorDetailsScreen extends StatelessWidget {
  final Author author;
  final ValueChanged<Book> onBookTapped;

  const AuthorDetailsScreen({
    super.key,
    required this.author,
    required this.onBookTapped,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(author.name)),
    body: Center(
      child: Column(
        children: [
          Expanded(
            child: BookList(
              books: author.books,
              onTap: (book) {
                onBookTapped(book);
              },
            ),
          ),
        ],
      ),
    ),
  );
}