
import 'author.dart';
import 'book.dart';

final libraryInstance =
Library()
  ..addBook(
    title: 'Girolles',
    authorName: 'France',
    isPopular: true,
    isNew: true,
  )
  ..addBook(
    title: 'Trompettes de la mort',
    authorName: 'France',
    isPopular: false,
    isNew: true,
  )
  ..addBook(
    title: 'Cèpes',
    authorName: 'France',
    isPopular: true,
    isNew: false,
  )
  ..addBook(
    title: 'Shitake',
    authorName: 'Japon',
    isPopular: false,
    isNew: false,
  );

class Library {
  final List<Book> allBooks = [];
  final List<Author> allAuthors = [];

  void addBook({
    required String title,
    required String authorName,
    required bool isPopular,
    required bool isNew,
  }) {
    var author = allAuthors.firstWhere(
          (author) => author.name == authorName,
      orElse: () {
        final value = Author(allAuthors.length, authorName);
        allAuthors.add(value);
        return value;
      },
    );
    var book = Book(allBooks.length, title, isPopular, isNew, author);

    author.books.add(book);
    allBooks.add(book);
  }

  Book getBook(String id) {
    return allBooks[int.parse(id)];
  }

  List<Book> get popularBooks => [...allBooks.where((book) => book.isPopular)];

  List<Book> get newBooks => [...allBooks.where((book) => book.isNew)];
}