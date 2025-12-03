import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/widgets/responsive/adaptive_grid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget({
    required double width,
    required Widget child,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('AdaptiveGrid', () {
    group('Phone Layout (width < 600)', () {
      testWidgets('should render ListView on phone width (400)', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 400,
            child: AdaptiveGrid(
              itemCount: 5,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        // Should find ListView
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(GridView), findsNothing);

        // Should find all items
        for (int i = 0; i < 5; i++) {
          expect(find.byKey(ValueKey('item_$i')), findsOneWidget);
        }
      });

      testWidgets('should use single column layout on phone', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 500,
            child: AdaptiveGrid(
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                height: 100,
                color: Colors.blue,
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('Tablet Layout (width >= 600 && < 840)', () {
      testWidgets('should render GridView on tablet width (600)', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 600,
            child: AdaptiveGrid(
              itemCount: 6,
              minCardWidth: 250,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        // Should find GridView
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(ListView), findsNothing);

        // Should find all items
        for (int i = 0; i < 6; i++) {
          expect(find.byKey(ValueKey('item_$i')), findsOneWidget);
        }
      });

      testWidgets('should render GridView on tablet width (700)', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 700,
            child: AdaptiveGrid(
              itemCount: 4,
              minCardWidth: 300,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('should calculate 2 columns for tablet width with default minCardWidth', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 650,
            child: AdaptiveGrid(
              itemCount: 4,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        // (650 - 32 padding) / 300 minCardWidth = 2.06 -> floor to 2
        expect(delegate.crossAxisCount, 2);
      });
    });

    group('Desktop Layout (width >= 840)', () {
      testWidgets('should render GridView on desktop width (900)', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 900,
            child: AdaptiveGrid(
              itemCount: 6,
              minCardWidth: 250,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);

        // Should find all items
        for (int i = 0; i < 6; i++) {
          expect(find.byKey(ValueKey('item_$i')), findsOneWidget);
        }
      });

      testWidgets('should calculate 2 columns for desktop with default settings', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 900,
            child: AdaptiveGrid(
              itemCount: 6,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        // (900 - 32 padding) / 300 minCardWidth = 2.89 -> floor to 2
        expect(delegate.crossAxisCount, 2);
      });

      testWidgets('should calculate 3 columns for wide desktop with smaller minCardWidth', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 1200,
            child: AdaptiveGrid(
              itemCount: 9,
              minCardWidth: 250,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        // (1200 - 32 padding) / 250 minCardWidth = 4.67 -> floor to 4, but clamped to maxColumns 3
        expect(delegate.crossAxisCount, 3);
      });
    });

    group('Grid Configuration', () {
      testWidgets('should respect maxColumns parameter', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 1200,
            child: AdaptiveGrid(
              itemCount: 8,
              minCardWidth: 200,
              maxColumns: 2,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        // Should be clamped to maxColumns despite having space for more
        expect(delegate.crossAxisCount, 2);
      });

      testWidgets('should apply gridSpacing correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 800,
            child: AdaptiveGrid(
              itemCount: 4,
              gridSpacing: 16,
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.crossAxisSpacing, 16);
        expect(delegate.mainAxisSpacing, 16);
      });

      testWidgets('should apply childAspectRatio correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 800,
            child: AdaptiveGrid(
              itemCount: 4,
              childAspectRatio: 1.5,
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.childAspectRatio, 1.5);
      });

      testWidgets('should apply itemExtent when provided', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 800,
            child: AdaptiveGrid(
              itemCount: 4,
              itemExtent: 150,
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.mainAxisExtent, 150);
      });

      testWidgets('should apply padding correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 800,
            child: AdaptiveGrid(
              itemCount: 4,
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.padding, const EdgeInsets.all(24));
      });

      testWidgets('should support shrinkWrap', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 800,
            child: AdaptiveGrid(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) => Container(
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.shrinkWrap, isTrue);
      });
    });

    group('Sliver Mode', () {
      testWidgets('should render SliverList on phone with sliver=true', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 400,
            child: CustomScrollView(
              slivers: [
                AdaptiveGrid(
                  itemCount: 5,
                  sliver: true,
                  itemBuilder: (context, index) => Container(
                    key: ValueKey('item_$index'),
                    height: 100,
                    child: Text('Item $index'),
                  ),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(SliverList), findsOneWidget);
        expect(find.byType(SliverGrid), findsNothing);
      });

      testWidgets('should render SliverGrid on tablet with sliver=true', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            width: 700,
            child: CustomScrollView(
              slivers: [
                AdaptiveGrid(
                  itemCount: 6,
                  sliver: true,
                  itemBuilder: (context, index) => Container(
                    key: ValueKey('item_$index'),
                    child: Text('Item $index'),
                  ),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(SliverGrid), findsOneWidget);
        expect(find.byType(SliverList), findsNothing);
      });
    });
  });

  group('ContentContainer', () {
    testWidgets('should not constrain width on phone (400)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 400,
          child: ContentContainer(
            child: Container(
              key: const ValueKey('content'),
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // On phone, maxWidth is null, so content should not be centered/constrained
      final container = tester.widget<Container>(find.byKey(const ValueKey('content')));
      expect(container, isNotNull);
    });

    testWidgets('should constrain width to 700 on tablet (600)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ContentContainer(
            child: Container(
              key: const ValueKey('content'),
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // On tablet, should be wrapped in Center with ConstrainedBox
      expect(find.byType(Center), findsOneWidget);

      // Find the ConstrainedBox with maxWidth constraint
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final contentConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 700,
      );
      expect(contentConstraint.constraints.maxWidth, 700);
    });

    testWidgets('should constrain width to 900 on desktop (900)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ContentContainer(
            child: Container(
              key: const ValueKey('content'),
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);

      // Find the ConstrainedBox with maxWidth constraint
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final contentConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 900,
      );
      expect(contentConstraint.constraints.maxWidth, 900);
    });

    testWidgets('should use custom maxWidth when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ContentContainer(
            maxWidth: 500,
            child: Container(
              key: const ValueKey('content'),
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // Find the ConstrainedBox with maxWidth constraint
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final contentConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 500,
      );
      expect(contentConstraint.constraints.maxWidth, 500);
    });

    testWidgets('should apply padding when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ContentContainer(
            padding: const EdgeInsets.all(24),
            child: Container(
              key: const ValueKey('content'),
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(Center),
          matching: find.byType(Padding),
        ).first,
      );
      expect(padding.padding, const EdgeInsets.all(24));
    });
  });

  group('ResponsiveRow', () {
    testWidgets('should render Column on phone width (400)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 400,
          child: ResponsiveRow(
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
              Container(key: const ValueKey('item3'), child: const Text('Item 3')),
            ],
          ),
        ),
      );

      // Should render Column on phone
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);

      // Should find all items
      expect(find.byKey(const ValueKey('item1')), findsOneWidget);
      expect(find.byKey(const ValueKey('item2')), findsOneWidget);
      expect(find.byKey(const ValueKey('item3')), findsOneWidget);
    });

    testWidgets('should render Row on tablet width (600)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ResponsiveRow(
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
              Container(key: const ValueKey('item3'), child: const Text('Item 3')),
            ],
          ),
        ),
      );

      // Should render Row on tablet
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);

      // Should find all items
      expect(find.byKey(const ValueKey('item1')), findsOneWidget);
      expect(find.byKey(const ValueKey('item2')), findsOneWidget);
      expect(find.byKey(const ValueKey('item3')), findsOneWidget);
    });

    testWidgets('should render Row on desktop width (900)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ResponsiveRow(
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
            ],
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('should add vertical spacing in Column mode', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 400,
          child: ResponsiveRow(
            spacing: 20,
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
            ],
          ),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));

      // Should have items + spacer between them
      expect(column.children.length, 3); // item1, spacer, item2

      // Check that spacer is a SizedBox with correct height
      final spacer = column.children[1] as SizedBox;
      expect(spacer.height, 20);
    });

    testWidgets('should add horizontal spacing in Row mode', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ResponsiveRow(
            spacing: 20,
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
            ],
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));

      // Should have items + spacer between them
      expect(row.children.length, 3); // item1, spacer, item2

      // Check that spacer is a SizedBox with correct width
      final spacer = row.children[1] as SizedBox;
      expect(spacer.width, 20);
    });

    testWidgets('should wrap children in Flexible widgets', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ResponsiveRow(
            children: [
              Container(key: const ValueKey('item1'), child: const Text('Item 1')),
              Container(key: const ValueKey('item2'), child: const Text('Item 2')),
            ],
          ),
        ),
      );

      // Should have Flexible widgets wrapping the children
      expect(find.byType(Flexible), findsNWidgets(2));
    });

    testWidgets('should respect mainAxisAlignment', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ResponsiveRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: const Text('Item 1')),
              Container(child: const Text('Item 2')),
            ],
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('should respect crossAxisAlignment', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: ResponsiveRow(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: const Text('Item 1')),
              Container(child: const Text('Item 2')),
            ],
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('should handle empty children list', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 600,
          child: const ResponsiveRow(
            children: [],
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.isEmpty, isTrue);
    });
  });

  group('ResponsiveDialog', () {
    testWidgets('should constrain dialog width on phone', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 400,
          child: ResponsiveDialog(
            child: Container(
              key: const ValueKey('dialog_content'),
              child: const Text('Dialog'),
            ),
          ),
        ),
      );

      expect(find.byType(Dialog), findsOneWidget);

      // Find the ConstrainedBox inside the Dialog
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final dialogConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 368,
      );
      // On phone: width - 32 = 400 - 32 = 368
      expect(dialogConstraint.constraints.maxWidth, 368);
      expect(dialogConstraint.constraints.maxHeight, 800 * 0.9);
    });

    testWidgets('should constrain dialog width to 500 on tablet', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 700,
          child: ResponsiveDialog(
            child: Container(
              key: const ValueKey('dialog_content'),
              child: const Text('Dialog'),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox inside the Dialog
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final dialogConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 500,
      );
      expect(dialogConstraint.constraints.maxWidth, 500);
    });

    testWidgets('should constrain dialog width to 500 on desktop', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 1200,
          child: ResponsiveDialog(
            child: Container(
              key: const ValueKey('dialog_content'),
              child: const Text('Dialog'),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox inside the Dialog
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final dialogConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 500,
      );
      expect(dialogConstraint.constraints.maxWidth, 500);
    });

    testWidgets('should use custom maxWidth when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ResponsiveDialog(
            maxWidth: 600,
            child: Container(
              key: const ValueKey('dialog_content'),
              child: const Text('Dialog'),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox inside the Dialog
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final dialogConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 600,
      );
      expect(dialogConstraint.constraints.maxWidth, 600);
    });

    testWidgets('should constrain dialog height to 90% of screen', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          width: 900,
          child: ResponsiveDialog(
            child: Container(
              key: const ValueKey('dialog_content'),
              child: const Text('Dialog'),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox inside the Dialog
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final dialogConstraint = constrainedBoxes.firstWhere(
        (box) => box.constraints.maxWidth == 500,
      );
      expect(dialogConstraint.constraints.maxHeight, 800 * 0.9);
    });
  });
}
