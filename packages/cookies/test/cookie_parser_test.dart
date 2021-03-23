import 'dart:io';

import 'package:marathon_cookies/marathon_cookies.dart';
import 'package:test/test.dart';

// TODO: actually test server responses instead of just testing the parser
void main() {
  test('isEmpty is true if header is empty', () {
    var cookies = CookieParser.fromCookieValue(null);
    expect(cookies.isEmpty, isTrue);
  });

  test('parses cookies from `cookie` header value', () {
    var cookies = CookieParser.fromCookieValue('foo=bar; baz=qux');
    expect(cookies.isEmpty, isFalse);
    expect(cookies.get('foo')!.value, equals('bar'));
    expect(cookies.get('baz')!.value, equals('qux'));
  });

  test('parses cookies from raw headers map', () {
    var cookies =
        CookieParser.fromHeader({HttpHeaders.cookieHeader: 'foo=bar; baz=qux'});
    expect(cookies.isEmpty, isFalse);
    expect(cookies.get('foo')!.value, equals('bar'));
    expect(cookies.get('baz')!.value, equals('qux'));
  });

  test('adds new cookie to cookies list', () {
    var cookies = CookieParser.fromCookieValue('foo=bar');
    expect(cookies.isEmpty, isFalse);
    expect(cookies.get('baz'), isNull);
    cookies.set('baz', 'qux');
    expect(cookies.get('baz')!.value, 'qux');
  });

  test('removes cookie from cookies list by name', () {
    var cookies = CookieParser.fromCookieValue('foo=bar; baz=qux');
    expect(cookies.get('baz')!.value, equals('qux'));
    cookies.removeFromResponse('baz');
    expect(cookies.get('baz'), isNull);
  });

  test('clears all cookies in list', () {
    var cookies = CookieParser.fromCookieValue('foo=bar; baz=qux');
    expect(cookies.get('baz')!.value, equals('qux'));
    cookies.clear();
    expect(cookies.isEmpty, isTrue);
  });

  test('folds all cookies into single set-cookie header value', () {
    var cookies = CookieParser.fromCookieValue('foo=bar');
    expect(cookies.toString(), equals('foo=bar; HttpOnly'));
    cookies.set('baz', 'qux', secure: true);
    expect(
      cookies.toString(),
      equals('foo=bar; HttpOnly, baz=qux; Secure; HttpOnly'),
    );
  });
}
