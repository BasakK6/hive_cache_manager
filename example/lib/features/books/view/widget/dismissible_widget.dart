part of '../book_view.dart';

class _DismissibleWidget extends StatelessWidget {
  const _DismissibleWidget({
    required this.itemKey,
    required this.onDismissed,
    required this.child,
    Key? key,
  }) : super(key: key);

  final String itemKey;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(itemKey),
      direction: DismissDirection.endToStart,
      background: buildBackground(context),
      onDismissed: (_) {
        onDismissed.call();
      },
      child: child,
    );
  }

  Container buildBackground(BuildContext context) {
    return Container(
      padding: const ProjectPadding.onlyRightDouble(),
      color: Theme.of(context).colorScheme.secondary,
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete),
    );
  }
}
