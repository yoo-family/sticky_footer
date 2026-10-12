import 'package:flutter/material.dart';
import 'package:sticky_footer/sticky_footer.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sticky_footer example',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _itemCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sticky_footer'),
        actions: [
          IconButton(
            tooltip: 'Fewer items (footer docks to the bottom)',
            icon: const Icon(Icons.remove),
            onPressed: () =>
                setState(() => _itemCount = (_itemCount - 1).clamp(0, 30)),
          ),
          IconButton(
            tooltip: 'More items (footer scrolls with the content)',
            icon: const Icon(Icons.add),
            onPressed: () =>
                setState(() => _itemCount = (_itemCount + 1).clamp(0, 30)),
          ),
        ],
      ),
      body: StickyFooter(
        padding: const EdgeInsets.all(16),
        footer: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '© sticky_footer — always docked to the bottom when short, '
            'always flows with the content when long.',
            textAlign: TextAlign.center,
          ),
        ),
        children: [
          Text(
            'Items: $_itemCount — add more with the + button above until '
            'the list overflows the screen, and watch the footer start '
            'scrolling with it instead of staying pinned.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _itemCount; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text('Item ${i + 1}'),
              ),
            ),
        ],
      ),
    );
  }
}
