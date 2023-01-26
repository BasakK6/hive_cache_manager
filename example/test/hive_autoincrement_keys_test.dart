import 'package:example/features/books/model/book.dart';
import 'package:example/project/hive_constants.dart';
import 'package:example/features/books/cache/book_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  test('Hive Cache Manager Test', () async {
    // initialize Hive before using
    Hive.init(HiveConstants.hiveDbName);

    // create your model objects
    Book firstBook = Book(
      title: 'Lord of The Rings - The Fellowship of the Ring',
      author: 'J. R. R. Tolkien',
      year: 1954,
      isbn: '9780618260515',
    );

    Book secondBook = Book(
      title: 'Lord of The Rings - The Two Towers',
      author: 'J. R. R. Tolkien',
      year: 1954,
      isbn: '9780261102361',
    );

    Book thirdBook = Book(
      title: 'Lord of The Rings - The Return of the King',
      author: 'J. R. R. Tolkien',
      year: 1955,
      isbn: '9780007136575',
    );

    // create and explicitly initialize a manager object
    BookCacheManager bookCacheManager = BookCacheManager("${HiveConstants.booksHiveBoxName}_autoincrement_keys");
    await bookCacheManager.init(isEncrypted: false);

    // clear all the objects written from the previous test run
    await bookCacheManager.clearAll();

    // the hive box should be empty since no items have been added yet
    expect(bookCacheManager.getValues(),[]);

    // add your model objects to hive
    List<Book> books = [firstBook, secondBook, thirdBook];
    await bookCacheManager.addItems(items: books);

    // test the functionality of the hive_cache_manager
    expect(bookCacheManager.getValues().first.isbn,'9780618260515');

    // remove the object named "thirdBook" from the hive
    // since the objects were added with a autoincrement key the key of the "thirdBook" should be 2 (first key is 0)
    await bookCacheManager.removeItem(key: 2);

    // there should be only 2 books left in the hive box
    expect(bookCacheManager.getValues().length, 2);

    // read the values whose keys start at 0 and ends at 1 (inclusive)
    Iterable<Book> otherBooks = bookCacheManager.getValuesBetween(startKey: 0, endKey: 1);

    // put the remaining model objects in an Iterable
    Iterable<Book> remainingBooks = [firstBook, secondBook];

    // "otherBooks" and "remainingBooks" should be equal
    expect(otherBooks, remainingBooks);
  });
}
