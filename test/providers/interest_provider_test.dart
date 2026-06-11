import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alu_connect/providers/interest_provider.dart';

void main() {
  late InterestProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = InterestProvider();
    await provider.initialized;
  });

  group('InterestProvider', () {
    test('loads default interests when no saved data', () {
      expect(provider.interests, containsAll(['Technology', 'Leadership']));
      expect(provider.interests.length, 5);
    });

    test('add inserts a new interest', () {
      provider.add('Entrepreneurship');
      expect(provider.interests, contains('Entrepreneurship'));
      expect(provider.interests.length, 6);
    });

    test('add trims whitespace', () {
      provider.add('  Robotics  ');
      expect(provider.interests, contains('Robotics'));
    });

    test('add ignores blank strings', () {
      final before = provider.interests.length;
      provider.add('   ');
      expect(provider.interests.length, before);
    });

    test('add ignores case-insensitive duplicates', () {
      provider.add('technology');
      expect(provider.interests.where((i) => i.toLowerCase() == 'technology').length, 1);
    });

    test('remove deletes an existing interest', () {
      provider.remove('Design');
      expect(provider.interests, isNot(contains('Design')));
    });

    test('remove on unknown interest is a no-op', () {
      final before = provider.interests.length;
      provider.remove('NonExistent');
      expect(provider.interests.length, before);
    });
  });
}
