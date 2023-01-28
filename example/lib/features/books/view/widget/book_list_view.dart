part of '../book_view.dart';

class BookListView extends StatelessWidget {
  const BookListView({
    required this.bookCacheManager,
    required this.books,
    Key? key,
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
          onDismissed: () async {
            // Remove the item from the data source.
            await bookCacheManager.removeItem(key: item.mapKey);
            //show a message to the user
            Utility().showSnackBar(
                "${item.title} ${BooksUIConstants.snackBarMessageSuffix}");
          },
          child: _BookCard(book: item),
        );
      },
    );
  }
}
