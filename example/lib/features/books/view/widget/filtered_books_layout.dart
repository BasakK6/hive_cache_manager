part of '../book_view.dart';

class FilteredBooksLayout extends StatelessWidget {
  const FilteredBooksLayout({
    required this.buildLayout,
    required this.bookCacheManager,
    Key? key,
  }) : super(key: key);

  final Widget Function(List<Book> data) buildLayout;
  final BookCacheManager bookCacheManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bookCacheManager.getListenable(),
      builder: (context, box, widget) {
        final List<Book> data = [];

        for (final Book book in bookCacheManager.getValues()) {
          //filter the books whose year information is 1995
          //change this filter as needed
          if (book.year == 1955) {
            data.add(book);
          }
        }

        return buildLayout(data);
      },
    );
  }
}
