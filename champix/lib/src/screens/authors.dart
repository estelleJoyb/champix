import 'package:flutter/material.dart';

import '../data/author.dart';
import '../data/library.dart';
import '../widgets/author_list.dart';

class AuthorsScreen extends StatelessWidget {
  final String title;
  final ValueChanged<Author> onTap;

  const AuthorsScreen({required this.onTap, this.title = 'Authors', super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: AuthorList(authors: libraryInstance.allAuthors, onTap: onTap),
  );
}