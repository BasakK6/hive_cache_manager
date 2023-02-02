import 'package:example/features/books/cache/book_cache_manager.dart';
import 'package:example/features/books/model/book.dart';
import 'package:example/features/books/model/dummy_book_data.dart';
import 'package:example/features/books/view/book_view.dart';
import 'package:example/project/hive_constants.dart';
import 'package:flutter/material.dart';

abstract class BookModelView extends State<BookView> {
  late final BookCacheManager bookCacheManager;
  late final List<Book> dummyBookData;
  final List<String> filterKeys = ["9780618260515", "9780007136575"];
  late final Future<void> future;

  @override
  void initState() {
    super.initState();
    bookCacheManager = BookCacheManager(
        "${HiveConstants.booksHiveBoxName}${HiveConstants.hiveBoxNameSuffix}");
    dummyBookData = DummyBookData.init().items;
    future = bookCacheManager.init(isEncrypted: true);
  }

  @override
  Future<void> dispose() async {
    await bookCacheManager.closeBox();
    super.dispose();
  }

  Future<void> addDummyBookDataToCache() async {
    await bookCacheManager.putItems(items: dummyBookData);
  }
}
