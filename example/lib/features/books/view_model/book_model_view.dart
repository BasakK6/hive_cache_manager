import 'package:example/features/books/model/book.dart';
import 'package:example/features/books/cache/book_cache_manager.dart';
import 'package:example/features/books/model/dummy_book_data.dart';
import 'package:flutter/material.dart';
import 'package:example/features/books/view/book_view.dart';
import 'package:example/project/hive_constants.dart';

abstract class BookModelView extends State<BookView> {
  late final BookCacheManager bookCacheManager ;
  late Future<bool> future;
  late final List<Book> dummyBookData;
  final List<String> filterKeys = ["9780618260515", "9780007136575"];

  @override
  void initState() {
    super.initState();
    bookCacheManager = BookCacheManager("${HiveConstants.booksHiveBoxName}${HiveConstants.hiveBoxNameSuffix}");
    future = initCacheManager();
    dummyBookData = DummyBookData.init().items;
  }

  Future<bool> initCacheManager() async{
    await bookCacheManager.init();
    return true;
  }

  @override
  void dispose() {
    bookCacheManager.closeBox();
    super.dispose();
  }

  void addDummyBookDataToCache(){
    bookCacheManager.putItems(items: dummyBookData);
  }

}
