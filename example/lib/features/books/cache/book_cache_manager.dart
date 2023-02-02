import 'package:example/features/books/model/book.dart';
import 'package:example/project/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_cache_manager/hive_cache_manager.dart';

class BookCacheManager extends ICacheManager<Book> {
  BookCacheManager(super.boxName);

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConstants.bookTypeId)) {
      Hive.registerAdapter(BookAdapter());
    }
  }
}
