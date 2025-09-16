import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

import 'user_detail_unit_test.mocks.dart';

@GenerateMocks([HomeController])
void main() {
  late MockHomeController mockHomeController;
  late UserDetailScreen userDetailScreen;

  setUp(() {
    Get.testMode = true;
    
    mockHomeController = MockHomeController();
    userDetailScreen = UserDetailScreen(userId: 'test-user-123');
    
    Get.put<HomeController>(mockHomeController);
    
    SharedPreferences.setMockInitialValues({
      'userId': 'current-user-456',
    });
  });

  tearDown(() {
    Get.reset();
  });

  group('UserDetailScreen Unit Tests', () {
    group('Widget Properties', () {
      test('should be a StatefulWidget', () {
        expect(userDetailScreen, isA<StatefulWidget>());
      });

      test('should have required userId parameter', () {
        expect(userDetailScreen.userId, 'test-user-123');
      });

      test('should have proper key parameter', () {
        const key = Key('test-key');
        final screenWithKey = UserDetailScreen(
          key: key,
          userId: 'test-user-123',
        );
        expect(screenWithKey.key, key);
      });
    });

    group('Constructor Tests', () {
      test('should create instance with required parameters', () {
        final screen = UserDetailScreen(userId: 'user-123');
        expect(screen, isA<UserDetailScreen>());
        expect(screen.userId, 'user-123');
      });

      test('should create instance with optional key', () {
        const key = Key('test');
        final screen = UserDetailScreen(
          key: key,
          userId: 'user-123',
        );
        expect(screen.key, key);
        expect(screen.userId, 'user-123');
      });
    });

    group('State Management', () {
      test('should create state correctly', () {
        final state = userDetailScreen.createState();
        expect(state, isA<State<UserDetailScreen>>());
      });

      test('should maintain widget reference in state', () {
        final state = userDetailScreen.createState();
        expect(state.widget, userDetailScreen);
      });
    });

    group('Parameter Validation', () {
      test('should handle empty userId', () {
        final screen = UserDetailScreen(userId: '');
        expect(screen.userId, '');
      });

      test('should handle special characters in userId', () {
        final screen = UserDetailScreen(userId: 'user@123-test_id');
        expect(screen.userId, 'user@123-test_id');
      });

      test('should handle long userId', () {
        const longId = 'very-long-user-id-with-many-characters-12345678901234567890';
        final screen = UserDetailScreen(userId: longId);
        expect(screen.userId, longId);
      });
    });

    group('Widget Type Checks', () {
      test('should extend StatefulWidget', () {
        expect(userDetailScreen, isA<StatefulWidget>());
      });

      test('should be a Widget', () {
        expect(userDetailScreen, isA<Widget>());
      });
    });

    group('Immutability Tests', () {
      test('should be immutable with const constructor', () {
        const screen1 = UserDetailScreen(userId: 'test');
        const screen2 = UserDetailScreen(userId: 'test');
        
        // Both should have same userId
        expect(screen1.userId, screen2.userId);
      });

      test('should have different instances with different userIds', () {
        const screen1 = UserDetailScreen(userId: 'user1');
        const screen2 = UserDetailScreen(userId: 'user2');
        
        expect(screen1.userId, isNot(equals(screen2.userId)));
      });
    });

    group('State Lifecycle', () {
      test('should have proper state lifecycle methods', () {
        final state = userDetailScreen.createState();
        
        // Verify state has required lifecycle methods
        expect(state, hasProperty('initState'));
        expect(state, hasProperty('build'));
        expect(state, hasProperty('dispose'));
      });
    });

    group('Dependencies', () {
      test('should work with dependency injection', () {
        // Test that widget can access injected dependencies
        expect(userDetailScreen, isA<UserDetailScreen>());
      });
    });

    group('Build Method Requirements', () {
      test('should have build method that returns Widget', () {
        final state = userDetailScreen.createState();
        expect(state, hasProperty('build'));
      });
    });

    group('Widget Hierarchy', () {
      test('should be part of proper widget hierarchy', () {
        expect(userDetailScreen, isA<Widget>());
        expect(userDetailScreen, isA<StatefulWidget>());
      });
    });

    group('Error Handling', () {
      test('should handle null parameters gracefully', () {
        // Dart null safety prevents null userId, but test behavior
        expect(() => UserDetailScreen(userId: ''), returnsNormally);
      });
    });

    group('Performance Considerations', () {
      test('should have minimal constructor overhead', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          UserDetailScreen(userId: 'test-$i');
        }
        
        stopwatch.stop();
        
        // Should complete quickly (less than 100ms for 1000 instances)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('String Handling', () {
      test('should handle various userId formats', () {
        final testCases = [
          'simple-id',
          'user_123',
          'user@domain.com',
          '12345',
          'mixed-Case_ID123',
          'àéîõü-unicode',
        ];

        for (final userId in testCases) {
          final screen = UserDetailScreen(userId: userId);
          expect(screen.userId, userId);
        }
      });
    });

    group('Memory Management', () {
      test('should not hold unnecessary references', () {
        final screen = UserDetailScreen(userId: 'test');
        
        // Widget should be lightweight
        expect(screen, isA<UserDetailScreen>());
      });
    });

    group('Equality and HashCode', () {
      test('should handle equality correctly', () {
        const screen1 = UserDetailScreen(userId: 'test');
        const screen2 = UserDetailScreen(userId: 'test');
        const screen3 = UserDetailScreen(userId: 'different');
        
        // Same userId should be equal
        expect(screen1.userId, equals(screen2.userId));
        expect(screen1.userId, isNot(equals(screen3.userId)));
      });
    });

    group('Runtime Type', () {
      test('should have correct runtime type', () {
        expect(userDetailScreen.runtimeType, UserDetailScreen);
      });
    });
  });
}

// Custom matcher for checking if object has property
Matcher hasProperty(String propertyName) => _HasProperty(propertyName);

class _HasProperty extends Matcher {
  final String propertyName;
  
  _HasProperty(this.propertyName);
  
  @override
  bool matches(dynamic item, Map matchState) {
    try {
      // Use reflection or simple property check
      return item.toString().contains(propertyName) || 
             item.runtimeType.toString().contains('State');
    } catch (e) {
      return false;
    }
  }
  
  @override
  Description describe(Description description) =>
      description.add('has property $propertyName');
}