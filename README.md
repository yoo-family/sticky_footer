# sticky_footer

A Flutter widget that keeps a footer pinned to the bottom of the screen
when content is short, and lets it scroll naturally right after the
content when it overflows — both in one widget, no manual height math.

## The problem

Two common approaches, and why neither covers both cases:

- `Column([Expanded(scrollable), footer])` — the footer stays pinned, but
  it **never** moves away even when the content above it grows past the
  screen; the scroll area just keeps shrinking.
- Put the footer as the last item in the list — it scrolls correctly with
  long content, but floats awkwardly mid-screen when the content is short.

## How it works

`StickyFooter` gives the scrollable content a minimum height equal to the
viewport, with an `Expanded` spacer between your content and the footer:

- **Short content** → the spacer absorbs the leftover space, pushing the
  footer down to the bottom of the screen (looks pinned).
- **Long content** → there's no leftover space, so the spacer collapses to
  zero and the footer sits right after your content, scrolling with it.

## Usage

```dart
import 'package:sticky_footer/sticky_footer.dart';

Scaffold(
  body: StickyFooter(
    padding: const EdgeInsets.all(16),
    children: const [
      MyHeader(),
      MyList(),
    ],
    footer: const MyFooter(),
  ),
)
```

Run the bundled example (`example/`) and use the +/− buttons to see the
footer switch between docked and scrolling as the list grows.

### Wrap it in a `SafeArea`

`StickyFooter` doesn't add a `SafeArea` for you, so on devices with a
bottom gesture bar (Android) or home indicator (iOS) the docked footer
can end up flush against — or hidden behind — the system UI. Wrap it
yourself:

```dart
Scaffold(
  body: SafeArea(
    bottom: true,
    child: StickyFooter(...),
  ),
)
```

## Limitations

- `children` must render as plain, non-virtualized widgets (a handful of
  cards, not a `ListView.builder`) — `IntrinsicHeight` needs to measure
  every child's real size, which conflicts with lazy/virtualized lists.
- For long or virtualized lists, get the same effect with
  `CustomScrollView` + `SliverList` + `SliverFillRemaining(hasScrollBody:
  false)` as the last sliver instead — same principle, different widgets.
- `IntrinsicHeight` costs more to lay out than a plain `Column`, so this
  is best suited to a handful of cards or a short list, not screens with
  hundreds of children.

## Additional information

Issues and pull requests are welcome on the
[GitHub repository](https://github.com/yoo-family/sticky_footer).
