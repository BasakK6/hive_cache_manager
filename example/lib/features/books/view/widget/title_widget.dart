part of '../book_view.dart';

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    required this.title,
    Key? key,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const ProjectPadding.all(),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: Colors.blue[800]),
      ),
    );
  }
}
