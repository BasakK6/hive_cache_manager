import 'package:example/project/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_cache_manager/hive_cache_manager.dart';

part 'book.g.dart';

@HiveType(typeId: HiveConstants.bookTypeId)
class Book extends IHiveModel{
  @HiveField(HiveConstants.bookIsbnFieldId)
  String isbn;
  @HiveField(HiveConstants.bookTitleFieldId)
  String title;
  @HiveField(HiveConstants.bookAuthorFieldId)
  String author;
  @HiveField(HiveConstants.bookYearFieldId)
  int year;

  Book({required this.title, required this.author, required this.year, required this.isbn});

  @override
  String get mapKey => isbn;
}
