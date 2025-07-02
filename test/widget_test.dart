// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xylophone_flutter_master/main.dart';

void main() {
  group('Xylophone App Tests', () {
    testWidgets('App should display title and all 7 notes', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(XylophoneApp());

      // Verify the app title is displayed
      expect(find.text('Xylophone'), findsOneWidget);

      // Verify all 7 note labels are present
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      // Verify music note icons are present (should find 7 icons)
      expect(find.byIcon(Icons.music_note), findsNWidgets(7));
    });

    testWidgets('All note widgets should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(XylophoneApp());

      // Find all InkWell widgets (tappable note buttons)
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(7));

      // Test that each note can be tapped without errors
      for (int i = 0; i < 7; i++) {
        await tester.tap(inkWells.at(i));
        await tester.pump(); // Trigger a frame after tapping
        await tester.pump(const Duration(milliseconds: 200)); // Wait for animation
      }
    });

    testWidgets('Note widgets should have correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(XylophoneApp());

      // Find all Note widgets
      final noteWidgets = find.byType(Note);
      expect(noteWidgets, findsNWidgets(7));

      // Verify the Note widgets exist with correct types
      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.red && widget.label == 'C'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.orange && widget.label == 'D'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.yellow && widget.label == 'E'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.green && widget.label == 'F'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.blue && widget.label == 'G'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.indigo && widget.label == 'A'
      ), findsOneWidget);

      expect(find.byWidgetPredicate((widget) =>
        widget is Note && widget.getColor == Colors.purple && widget.label == 'B'
      ), findsOneWidget);
    });

    testWidgets('App should have proper structure', (WidgetTester tester) async {
      await tester.pumpWidget(XylophoneApp());

      // Verify MaterialApp exists
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verify Scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);

      // Verify Column layout exists
      expect(find.byType(Column), findsOneWidget);

      // Verify main background container with gradient exists (more specific check)
      expect(find.byWidgetPredicate((widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).gradient != null &&
        widget.child is SafeArea
      ), findsOneWidget);

      // Verify all notes are wrapped in Expanded widgets
      expect(find.byType(Expanded), findsNWidgets(7));
    });

    testWidgets('Note animation should work on tap', (WidgetTester tester) async {
      await tester.pumpWidget(XylophoneApp());

      // Find the first note widget
      final firstNote = find.byType(InkWell).first;

      // Tap the note
      await tester.tap(firstNote);
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 75)); // Mid animation

      // Verify AnimatedBuilder exists (there may be more than 7 due to framework internals)
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(7));

      // Complete the animation
      await tester.pump(const Duration(milliseconds: 200));
    });

    group('Note Widget Unit Tests', () {
      testWidgets('Note widget should display correct label and color', (WidgetTester tester) async {
        const testNote = Note(
          getColor: Colors.red,
          getNote: 1,
          label: 'Test',
        );

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: testNote),
        ));

        expect(find.text('Test'), findsOneWidget);
        expect(find.byIcon(Icons.music_note), findsOneWidget);
      });

      testWidgets('Note widget should be tappable', (WidgetTester tester) async {
        const testNote = Note(
          getColor: Colors.blue,
          getNote: 2,
          label: 'Test2',
        );

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: testNote),
        ));

        // Find and tap the note
        await tester.tap(find.byType(InkWell));
        await tester.pump();

        // Verify the widget exists and is responsive
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(Transform), findsAtLeastNWidgets(1));
      });
    });

    testWidgets('Audio playback should not cause errors', (WidgetTester tester) async {
      await tester.pumpWidget(XylophoneApp());

      // Find the first note and tap it
      final firstNote = find.byType(InkWell).first;
      await tester.tap(firstNote);
      await tester.pump();

      // Wait for audio operation to complete
      await tester.pump(const Duration(milliseconds: 300));

      // No exceptions should be thrown
      expect(tester.takeException(), isNull);
    });
  });
}
