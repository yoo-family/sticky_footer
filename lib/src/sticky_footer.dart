import 'package:flutter/widgets.dart';

/// A scrollable column that keeps [footer] pinned to the bottom of the
/// viewport when [children] don't fill the screen, and lets [footer]
/// scroll away right after [children] once they overflow it.
///
/// Neither `Column([Expanded(scrollable), footer])` (footer never moves
/// down with long content) nor appending the footer as the last list item
/// (it floats mid-screen when content is short) covers both cases at once.
/// [StickyFooter] does, by giving the scroll area a minimum height equal to
/// the viewport and letting an [Expanded] spacer absorb whatever room is
/// left over.
///
/// ```dart
/// Scaffold(
///   body: StickyFooter(
///     footer: const MyFooter(),
///     children: const [MyHeader(), MyList()],
///   ),
/// )
/// ```
///
/// Only works when [children] render as plain, non-virtualized widgets
/// (a short list of cards, not a `ListView.builder`) — see the package
/// README for the virtualized-list alternative.
class StickyFooter extends StatelessWidget {
  const StickyFooter({
    super.key,
    required this.children,
    required this.footer,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.controller,
  });

  /// Widgets laid out above the footer, in a [Column].
  final List<Widget> children;

  /// The widget pinned to the bottom when [children] are short.
  final Widget footer;

  /// Cross-axis alignment for the inner [Column] (children and footer).
  final CrossAxisAlignment crossAxisAlignment;

  /// Optional padding applied around [children] and [footer] together.
  ///
  /// Applied inside the height-constrained column (not on the
  /// [SingleChildScrollView] itself), so it correctly counts toward the
  /// "does this fill the viewport" calculation that pins the footer.
  final EdgeInsetsGeometry? padding;

  /// Scroll physics for the underlying [SingleChildScrollView].
  final ScrollPhysics physics;

  /// Optional scroll controller for the underlying [SingleChildScrollView].
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final column = Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...children,
            const Expanded(child: SizedBox.shrink()),
            footer,
          ],
        );
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: padding == null
                  ? column
                  : Padding(padding: padding!, child: column),
            ),
          ),
        );
      },
    );
  }
}
