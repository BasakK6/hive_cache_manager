import 'package:example/features/books/cache/book_cache_manager.dart';
import 'package:example/features/books/constants/books_ui_constants.dart';
import 'package:example/features/books/model/book.dart';
import 'package:example/features/books/view_model/book_model_view.dart';
import 'package:example/project/project_padding.dart';
import 'package:example/project/utility.dart';
import 'package:flutter/material.dart';

part 'widget/book_card.dart';

part 'widget/dismissible_widget.dart';

part 'widget/title_widget.dart';

part 'widget/book_list_view.dart';

part 'widget/filtered_books_layout.dart';

class BookView extends StatefulWidget {
  const BookView({Key? key}) : super(key: key);

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends BookModelView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const ProjectPadding.all(),
        child: buildBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(BooksUIConstants.appBarTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: addDummyBookDataToCache,
        ),
      ],
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: initCacheManager(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TitleWidget(title: BooksUIConstants.allDataTitle),
                bookCacheManager.getValueListenableBuilder(
                    buildLayout: buildBooksLayout),
                const _TitleWidget(title: BooksUIConstants.filteredByKeyTitle),
                bookCacheManager.getValueListenableBuilder(
                    buildLayout: buildBooksLayout, keys: filterKeys),
                const _TitleWidget(
                    title: BooksUIConstants.filteredByPropertyTitle),
                buildFilteredBooksLayout(),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildBooksLayout(List<Book> books) {
    return books.isEmpty
        ? const Center(child: Text(BooksUIConstants.emptyCacheMessage))
        : buildListView(books);
  }

  Widget buildListView(List<Book> books) {
    return BookListView(
      bookCacheManager: bookCacheManager,
      books: books,
    );
  }

  Widget buildFilteredBooksLayout() {
    return FilteredBooksLayout(
      bookCacheManager: bookCacheManager,
      buildLayout: buildBooksLayout,
    );
  }
}
