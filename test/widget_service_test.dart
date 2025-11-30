import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/widget_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetService', () {
    late List<MethodCall> methodCalls;

    setUp(() {
      methodCalls = [];
      // Set up mock method channel handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.medicapp.medicapp/widget'),
        (MethodCall methodCall) async {
          methodCalls.add(methodCall);
          return null;
        },
      );
    });

    tearDown(() {
      // Clean up mock handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.medicapp.medicapp/widget'),
        null,
      );
    });

    test('should be a singleton', () {
      final instance1 = WidgetService.instance;
      final instance2 = WidgetService.instance;

      expect(identical(instance1, instance2), isTrue);
    });

    test('should call updateWidget method on channel', () async {
      await WidgetService.instance.updateWidget();

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'updateWidget');
    });

    test('should handle PlatformException gracefully', () async {
      // Set up handler that throws PlatformException
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.medicapp.medicapp/widget'),
        (MethodCall methodCall) async {
          throw PlatformException(code: 'ERROR', message: 'Widget not found');
        },
      );

      // Should not throw
      await expectLater(
        WidgetService.instance.updateWidget(),
        completes,
      );
    });

    test('should handle MissingPluginException gracefully', () async {
      // Set up handler that throws MissingPluginException
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.medicapp.medicapp/widget'),
        (MethodCall methodCall) async {
          throw MissingPluginException('No implementation found');
        },
      );

      // Should not throw
      await expectLater(
        WidgetService.instance.updateWidget(),
        completes,
      );
    });

    test('should be callable multiple times', () async {
      await WidgetService.instance.updateWidget();
      await WidgetService.instance.updateWidget();
      await WidgetService.instance.updateWidget();

      expect(methodCalls.length, 3);
      expect(methodCalls.every((call) => call.method == 'updateWidget'), isTrue);
    });
  });
}
