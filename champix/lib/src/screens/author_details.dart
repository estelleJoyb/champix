import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets/champignon_list.dart';

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
    body: const Center(
      child: Column(
        children: [
          SizedBox(width: 10,),
          /*Expanded(
            child: ChampignonList(
              champignons: author.books,
              onTap: (book) {
                onBookTapped(book);
              },
            ),
          ),*/
        ],
      ),
    ),
  );
}