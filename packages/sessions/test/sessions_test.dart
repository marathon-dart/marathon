import 'package:marathon_sessions/src/uuid.dart';
import 'package:test/test.dart';

void main() {
  group('UUID conforms to specification:', () {
    late String uuid;

    setUp(() {
      uuid = genUUID();
      print(uuid);
    });

    test('Has correct length', () {
      expect(uuid.length, equals(36));
    });

    test('Has dashes in right spots', () {
      expect(uuid.codeUnitAt(8), equals('-'.codeUnits[0]));
      expect(uuid.codeUnitAt(13), equals('-'.codeUnits[0]));
      expect(uuid.codeUnitAt(18), equals('-'.codeUnits[0]));
      expect(uuid.codeUnitAt(23), equals('-'.codeUnits[0]));
    });

    test('Has correct version and variant', () {
      expect(uuid.codeUnitAt(14), equals('4'.codeUnits[0]));
      expect(uuid.codeUnitAt(19), equals('1'.codeUnits[0]));
    });
  });
}
