part of '../book_view.dart';

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.book,
    Key? key,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const ProjectPadding.all(),
        child: _buildListTile(context),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: _buildTitle(context),
      subtitle: Padding(
        padding: const ProjectPadding.onlyTop(),
        child: _buildSubtitle(),
      ),
      trailing: Text("${book.year}"),
    );
  }

  Icon _buildLeading(BuildContext context) {
    return Icon(
      Icons.menu_book,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      book.title,
      style: Theme.of(context).textTheme.subtitle1?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Column _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${BooksUIConstants.authorTitle} ${book.author}"),
        Text("${BooksUIConstants.isbnTitle} ${book.isbn}"),
      ],
    );
  }
}
