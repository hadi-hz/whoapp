import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test3/shared/change_lang.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';

import 'changelang_widget_test.mocks.dart';

@GenerateMocks([LanguageController])
void main() {
  late MockLanguageController mockLanguageController;

  setUp(() {
    mockLanguageController = MockLanguageController();
    
    when(mockLanguageController.isChangingLanguage).thenReturn(false.obs);
    
    Get.put<LanguageController>(mockLanguageController);
  });

  tearDown(() {
    Get.reset();
  });

  Widget createTestWidget() {
    return GetMaterialApp(
      home: Scaffold(
        body: ChangeLang(),
      ),
    );
  }

  group('ChangeLang Widget Tests', () {
    testWidgets('should render language button correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ChangeLang), findsOneWidget);
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should show circular button with language icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.decoration, isA<BoxDecoration>());
      
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, isNotNull);

      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should show popup menu when tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('should display SVG flags in popup menu items', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsNWidgets(3));
      expect(find.text('English'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('should call changeLanguage when English is selected', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      verify(mockLanguageController.changeLanguage('en')).called(1);
    });

    testWidgets('should call changeLanguage when French is selected', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('French'));
      await tester.pumpAndSettle();

      verify(mockLanguageController.changeLanguage('fr')).called(1);
    });

    testWidgets('should call changeLanguage when Italian is selected', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Italian'));
      await tester.pumpAndSettle();

      verify(mockLanguageController.changeLanguage('it')).called(1);
    });

    testWidgets('should show loading indicator when changing language', (tester) async {
      when(mockLanguageController.isChangingLanguage).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.language), findsNothing);
    });

    testWidgets('should disable popup when changing language', (tester) async {
      when(mockLanguageController.isChangingLanguage).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      final popupButton = tester.widget<PopupMenuButton<String>>(
        find.byType(PopupMenuButton<String>),
      );
      expect(popupButton.enabled, false);
    });

    testWidgets('should enable popup when not changing language', (tester) async {
      when(mockLanguageController.isChangingLanguage).thenReturn(false.obs);

      await tester.pumpWidget(createTestWidget());

      final popupButton = tester.widget<PopupMenuButton<String>>(
        find.byType(PopupMenuButton<String>),
      );
      expect(popupButton.enabled, true);
    });

    testWidgets('should have correct container size', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 40);
      expect(container.constraints?.maxHeight, 40);
    });

    testWidgets('should show correct flag assets', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final svgPictures = tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      
      // Note: You may need to adjust these asset paths based on your actual assets
      expect(svgPictures.length, 3);
    });

    testWidgets('should handle tap outside popup menu', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);

      // Tap outside the menu
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsNothing);
    });

    testWidgets('should have proper semantics for accessibility', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      
      // Test that the button is semantically labeled
      final semantics = tester.getSemantics(find.byType(PopupMenuButton<String>));
      expect(semantics.hasFlag(SemanticsFlag.isButton), true);
    });
  });
}