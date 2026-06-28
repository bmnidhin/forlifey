import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forlifey/main.dart';
import 'package:forlifey/state/app_state.dart';

// Helper to pump multiple intermediate frames for smooth transitions
Future<void> pumpFrames(WidgetTester tester, {int count = 10, int msPerFrame = 50}) async {
  for (int i = 0; i < count; i++) {
    await tester.pump(Duration(milliseconds: msPerFrame));
  }
}

void main() {
  testWidgets('Checklist workflow smoke test', (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(
      AppStateProvider(
        notifier: AppState(),
        child: const MyApp(),
      ),
    );
    await pumpFrames(tester, count: 5);

    // Verify we start on "My Checklists" screen and show the empty state since there are no active checklists.
    expect(find.text('My Checklists'), findsOneWidget);
    expect(find.text('No Active Checklists'), findsOneWidget);
    expect(find.text('Explore Templates'), findsOneWidget);

    // 2. Tap the "Explore Templates" redirect link button.
    await tester.tap(find.text('Explore Templates'));
    await pumpFrames(tester, count: 10); // Advance frames for tab transition

    // Verify we have transitioned to the Discover screen
    expect(find.text('Curated templates to jumpstart your routines.'), findsOneWidget);
    expect(find.text('Morning Routine'), findsOneWidget);
    expect(find.text('Travel Packing Essentials'), findsOneWidget);

    // 3. Tap on the "Morning Routine" template card to open its preview page.
    await tester.tap(find.text('Morning Routine'));
    await pumpFrames(tester, count: 15); // Advance frames for page slide transition

    // Verify template preview page details
    expect(find.text('Template Preview'), findsOneWidget);
    expect(find.text('Use this Template'), findsOneWidget);
    expect(find.text('Drink a large glass of water'), findsOneWidget);

    // 4. Instantiate the checklist
    await tester.tap(find.text('Use this Template'));
    await pumpFrames(tester, count: 15); // Advance frames for page replace transition

    // Verify we are now on the checklist execution page
    expect(find.text('0%'), findsOneWidget); // Progress starts at 0%
    expect(find.text('Drink a large glass of water'), findsOneWidget);
    
    // Tap on the first item checkbox/text to toggle its completion
    await tester.tap(find.text('Drink a large glass of water'));
    await pumpFrames(tester, count: 10); // Advance frames for checkbox animation and progress update

    // Verify progress changes (1 out of 5 items is 20%)
    expect(find.text('20%'), findsOneWidget);

    // 5. Navigate back to My Checklists screen
    await tester.tap(find.byIcon(CupertinoIcons.back));
    await pumpFrames(tester, count: 15); // Advance frames for back navigation

    // Tap the tab bar item to switch back to Checklists tab
    await tester.tap(find.text('Checklists'));
    await pumpFrames(tester, count: 10);

    // Verify the checklist is now listed in My Checklists tab
    expect(find.text('My Checklists'), findsOneWidget);
    expect(find.text('Morning Routine'), findsOneWidget);
    expect(find.text('1 of 5 items completed'), findsOneWidget);
  });

  testWidgets('Checklist workflow smoke test (Mobile Viewport)', (WidgetTester tester) async {
    // Set screen size to mobile portrait
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      AppStateProvider(
        notifier: AppState(),
        child: const MyApp(),
      ),
    );
    await pumpFrames(tester, count: 5);

    // Tap the "Explore Templates" redirect link button.
    await tester.tap(find.text('Explore Templates'));
    await pumpFrames(tester, count: 10);

    // Verify we transitioned to Discover screen (which renders as a ListView on mobile)
    expect(find.text('Curated templates to jumpstart your routines.'), findsOneWidget);
    expect(find.text('Morning Routine'), findsOneWidget);

    // Tap on the "Morning Routine" template card to open its preview page.
    await tester.tap(find.text('Morning Routine'));
    await pumpFrames(tester, count: 15);

    // Verify template details are displayed on the preview screen
    expect(find.text('Template Preview'), findsOneWidget);
    expect(find.text('Use this Template'), findsOneWidget);

    // Instantiate the checklist
    await tester.tap(find.text('Use this Template'));
    await pumpFrames(tester, count: 15);

    // Verify checklist detail screen progress starts at 0%
    expect(find.text('0%'), findsOneWidget);
  });
}
