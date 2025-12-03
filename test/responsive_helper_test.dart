import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/utils/responsive_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Breakpoints', () {
    test('should have correct constant values', () {
      expect(Breakpoints.phone, 600);
      expect(Breakpoints.tablet, 840);
      expect(Breakpoints.desktop, 1200);
    });
  });

  group('ResponsiveHelper.getDeviceType()', () {
    testWidgets('should return phone for width < 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDeviceType(context), DeviceType.phone);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return tablet for width 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDeviceType(context), DeviceType.tablet);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return tablet for width 700', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDeviceType(context), DeviceType.tablet);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return desktop for width 900', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDeviceType(context), DeviceType.desktop);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return desktop for width 1300', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDeviceType(context), DeviceType.desktop);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.isPhone()', () {
    testWidgets('should return true for width < 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isPhone(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return false for width 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isPhone(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return false for width > 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isPhone(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.isTablet()', () {
    testWidgets('should return false for width < 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTablet(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTablet(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width 700', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTablet(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return false for width >= 840', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(840, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTablet(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.isTabletOrLarger()', () {
    testWidgets('should return false for width < 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTabletOrLarger(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width 600', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTabletOrLarger(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width 900', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isTabletOrLarger(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.isDesktop()', () {
    testWidgets('should return false for width < 840', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isDesktop(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width 840', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(840, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isDesktop(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for width > 840', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isDesktop(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.isLandscape()', () {
    testWidgets('should return false for portrait orientation', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData.fromView(tester.view).copyWith(
            size: const Size(400, 800),
          ),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isLandscape(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return true for landscape orientation', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData.fromView(tester.view).copyWith(
            size: const Size(800, 400),
          ),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isLandscape(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getGridColumns()', () {
    testWidgets('should return 1 for phone width (400)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridColumns(context), 1);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 2 for tablet width (600)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridColumns(context), 2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 2 for tablet width (700)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridColumns(context), 2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 3 for desktop width (900)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridColumns(context), 3);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 3 for desktop width (1300)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridColumns(context), 3);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getCardGridColumns()', () {
    testWidgets('should calculate columns based on available width with default minCardWidth', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(650, 800)),
          child: Builder(
            builder: (context) {
              // (650 - 32) / 300 = 2.06 -> floor to 2
              expect(ResponsiveHelper.getCardGridColumns(context), 2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate columns with custom minCardWidth', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(650, 800)),
          child: Builder(
            builder: (context) {
              // (650 - 32) / 200 = 3.09 -> floor to 3
              expect(ResponsiveHelper.getCardGridColumns(context, minCardWidth: 200), 3);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should clamp minimum to 1', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(100, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardGridColumns(context), 1);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should clamp maximum to 4', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(2000, 800)),
          child: Builder(
            builder: (context) {
              // (2000 - 32) / 300 = 6.56 -> floor to 6 -> clamp to 4
              expect(ResponsiveHelper.getCardGridColumns(context), 4);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getContentMaxWidth()', () {
    testWidgets('should return null for phone width (400)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getContentMaxWidth(context), isNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 700 for tablet width (600)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getContentMaxWidth(context), 700);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 700 for tablet width (700)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getContentMaxWidth(context), 700);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 900 for desktop width (900)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getContentMaxWidth(context), 900);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 900 for desktop width (1300)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getContentMaxWidth(context), 900);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getHorizontalPadding()', () {
    testWidgets('should return 16 for phone width (400)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getHorizontalPadding(context), 16);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 24 for tablet width (600)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getHorizontalPadding(context), 24);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 24 for tablet width (700)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getHorizontalPadding(context), 24);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 32 for desktop width (900)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getHorizontalPadding(context), 32);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 32 for desktop width (1300)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getHorizontalPadding(context), 32);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getDialogMaxWidth()', () {
    testWidgets('should return width - 32 for phone width (400)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDialogMaxWidth(context), 368);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 500 for tablet width (600)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDialogMaxWidth(context), 500);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 500 for desktop width (900)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getDialogMaxWidth(context), 500);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getFormMaxWidth()', () {
    testWidgets('should return infinity for phone width (400)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getFormMaxWidth(context), double.infinity);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 600 for tablet width (600)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getFormMaxWidth(context), 600);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 600 for desktop width (900)', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getFormMaxWidth(context), 600);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper.getCardAspectRatio()', () {
    testWidgets('should return 2.5 for phone with isCompact=false', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardAspectRatio(context), 2.5);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 3.5 for phone with isCompact=true', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardAspectRatio(context, isCompact: true), 3.5);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 2.2 for tablet with isCompact=false', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardAspectRatio(context), 2.2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 3.0 for tablet with isCompact=true', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardAspectRatio(context, isCompact: true), 3.0);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return 2.2 for desktop with isCompact=false', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getCardAspectRatio(context), 2.2);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveExtension', () {
    testWidgets('should provide deviceType getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(context.deviceType, DeviceType.tablet);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide isPhone getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isPhone, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide isTablet getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isTablet, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide isTabletOrLarger getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isTabletOrLarger, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide isDesktop getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(900, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isDesktop, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide isLandscape getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData.fromView(tester.view).copyWith(
            size: const Size(800, 400),
          ),
          child: Builder(
            builder: (context) {
              expect(context.isLandscape, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide gridColumns getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.gridColumns, 2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide contentMaxWidth getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.contentMaxWidth, 700);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide horizontalPadding getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.horizontalPadding, 24);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide dialogMaxWidth getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.dialogMaxWidth, 500);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide formMaxWidth getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.formMaxWidth, 600);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide screenWidth getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.screenWidth, 700);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should provide screenHeight getter', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Builder(
            builder: (context) {
              expect(context.screenHeight, 800);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
