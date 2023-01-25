part of '../book_view.dart';

class BookListView extends StatelessWidget {
  const BookListView({
    Key? key,
    required this.bookCacheManager,
    required this.books,
  }) : super(key: key);

  final List<Book> books;
  final BookCacheManager bookCacheManager;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        final item = books.elementAt(index);

        return _DismissibleWidget(
          itemKey: item.mapKey,
          onDismissed: () {
            // Remove the item from the data source.
            bookCacheManager.removeItem(key: item.mapKey);
            //show a message to the user
            Utility().showSnackBar(context,
                "${item.title} ${BooksUIConstants.snackBarMessageSuffix}");
          },
          child: _BookCard(book: item),
        );
      },
    );
  }
}
