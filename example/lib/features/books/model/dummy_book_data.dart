import 'package:example/features/books/model/book.dart';

class DummyBookData {
  late final List<Book> _items;

  List<Book> get items => _items;

  DummyBookData.init() {
    final Book firstBook = Book(
      title: 'Lord of The Rings - The Fellowship of the Ring',
      author: 'J. R. R. Tolkien',
      year: 1954,
      isbn: '9780618260515',
    );

    final Book secondBook = Book(
      title: 'Lord of The Rings - The Two Towers',
      author: 'J. R. R. Tolkien',
      year: 1954,
      isbn: '9780261102361',
    );

    final Book thirdBook = Book(
      title: 'Lord of The Rings - The Return of the King',
      author: 'J. R. R. Tolkien',
      year: 1955,
      isbn: '9780007136575',
    );

    _items = [firstBook, secondBook, thirdBook];
  }
}
