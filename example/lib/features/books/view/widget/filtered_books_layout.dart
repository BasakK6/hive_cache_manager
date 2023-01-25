part of '../book_view.dart';

class FilteredBooksLayout extends StatelessWidget {
  const FilteredBooksLayout({
    Key? key,
    required this.buildLayout,
    required this.bookCacheManager,
  }) : super(key: key);

  final Widget Function(List<Book> data) buildLayout;
  final BookCacheManager bookCacheManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bookCacheManager.getListenable(),
      builder: (context, box, widget) {
        List<Book> data = [];

        for (Book book in bookCacheManager.getValues()) {
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
