import 'package:example/features/books/model/book.dart';
import 'package:example/project/hive_constants.dart';
import 'package:example/features/books/cache/book_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  test('Hive Model Specific Keys Test', () async {
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
    BookCacheManager bookCacheManager = BookCacheManager("${HiveConstants.booksHiveBoxName}_model_specific_keys");
    await bookCacheManager.init(isEncrypted: false);

    //clear all the objects written from the previous test run
    await bookCacheManager.clearAll();

    // the hive box should be empty since no items have been added yet
    expect(bookCacheManager.getValues(),[]);

    // add your model objects to hive box
    /*
    await bookCacheManager.putItem(item: firstBook);
    await bookCacheManager.putItem(item: secondBook);
    await bookCacheManager.putItem(item: thirdBook);
    */
    bookCacheManager.putItems(items: [firstBook, secondBook, thirdBook]);

    // test the functionality of the hive_cache_manager
    expect(bookCacheManager.getItem(key: thirdBook.mapKey)?.year, 1955);

    // remove a specific object from the hive box
    bookCacheManager.removeItem(key: secondBook.mapKey);

    // there should be only 2 books left in the hive box
    expect(bookCacheManager.getValues().length, 2);

    // remove the rest of the books
    await bookCacheManager.removeItems(keys: [firstBook.mapKey, thirdBook.mapKey]);

    // the hive box should be empty
    expect(bookCacheManager.getValues().length, 0);

    // close the hive box
    await bookCacheManager.closeBox();

    // the hive box should not be open
    expect(bookCacheManager.isHiveBoxOpen, false);
  });
}
