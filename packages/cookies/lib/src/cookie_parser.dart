import 'dart:io';

import 'package:marathon/marathon.dart';

/// Parses cookies from the `Cookie` header of a [Request].
///
/// Stores all cookies in a [cookies] list, and has convenience
/// methods to manipulate this list.
///
/// `toString()` method converts list items to a `Set-Cookie`
/// HTTP header value according to RFC 2109 spec (deprecated).
class CookieParser {
  /// A list of parsed cookies.
  final List<Cookie> cookies = [];

  /// Creates a new [CookieParser] by parsing the `Cookie` header [value].
  CookieParser.fromCookieValue(String? value) {
    if (value != null) cookies.addAll(_parseCookieString(value));
  }

  /// Factory constructor to create a new instance from request [headers].
  factory CookieParser.fromHeader(Map<String, dynamic> headers) {
    return CookieParser.fromCookieValue(headers[HttpHeaders.cookieHeader]);
  }

  /// Denotes whether the [cookies] list is empty.
  bool get isEmpty => cookies.isEmpty;

  /// Retrieves a cookie by [name].
  Cookie? get(String name) {
    try {
      return cookies.firstWhere((Cookie cookie) => cookie.name == name);
    } on StateError catch (_) {
      return null;
    }
  }

  /// Adds a new cookie to [cookies] list if no cookie with [name] already
  /// exists. Otherwise, updates the cookie with [name].
  Cookie set(
    String name,
    String value, {
    String? domain,
    String? path,
    DateTime? expires,
    bool? httpOnly,
    bool? secure,
    int? maxAge,
  }) {
    var cookie = Cookie(name, value);
    if (domain != null) cookie.domain = domain;
    if (path != null) cookie.path = path;
    if (expires != null) cookie.expires = expires;
    if (httpOnly != null) cookie.httpOnly = httpOnly;
    if (secure != null) cookie.secure = secure;
    if (maxAge != null) cookie.maxAge = maxAge;

    // Update existing cookie, or append new one to list.
    var index = cookies.indexWhere((item) => item.name == name);
    if (index != -1) {
      cookies.replaceRange(index, index + 1, [cookie]);
    } else {
      cookies.add(cookie);
    }
    return cookie;
  }

  /// Edits the cookie which corresponds to [name] such that the cookie will be
  /// deleted upon the response's arrival at the browser.
  ///
  /// This is performed per the specification outlined in RFC 6265, whereby
  /// we set the target cookie's expiration DateTime to a DateTime that is
  /// guaranteed to be in the past.
  void removeFromClient(String name) {
    DateTime expires = DateTime.utc(1970, 11, 9);

    var retrievedCookies =
        cookies.where((Cookie cookie) => cookie.name == name);
    if (retrievedCookies.length == 0) {
      throw Exception('Cookie does not exsist');
    } else if (retrievedCookies.length > 1) {
      throw Exception('Multiple Cookies with the same name exsist');
    }
    retrievedCookies.first.expires = expires;
  }

  /// Removes the cookie which corresponds to [name] from the Response.
  ///
  /// Note that this method does NOT delete the cookie from the client browser;
  /// it just guarantees that (if the client browser has a cookie called [name])
  /// that cookie will not be edited.
  ///
  /// This method does not protect against rewriting a removed cookie.
  /// For example:
  /// ```dart
  /// parser.removeFromResponse("cookieName");
  /// parser.set("cookieName", "newValue");
  /// ```
  /// This code snippet would result in a Response which INCLUDED a "cookieName"
  /// cookie. On the client side, the Response would be received and
  /// "cookieName" would be overwritten or set with "newValue".
  void removeFromResponse(String name) {
    cookies.removeWhere((element) => element.name == name);
  }

  /// Clears the cookie list.
  ///
  /// Note that this method
  void clear() => cookies.clear();

  /// Converts the cookies to a string value to use in a `Set-Cookie` header.
  ///
  /// This implements the old RFC 2109 spec, which allowed for multiple
  /// cookies to be folded into a single `Set-Cookie` header value,
  /// separated by commas.
  ///
  /// As of RFC 6265, this folding mechanism is deprecated in favour of
  /// a multi-header approach. The multi-header approach is used by default in
  /// the middleware, but this [toString] method is implemented according to the
  /// RFC 2109 spec for testing/legacy purposes.
  @Deprecated('This method folds all the currently stored cookies into one set-'
      'cookie header. This behavior is deprecated by RFC 6265.')
  String toString() {
    return cookies.fold(
      '',
      (prev, element) => prev.isEmpty
          ? element.toString()
          : '${prev.toString()}, ${element.toString()}',
    );
  }
}

/// Parse a Cookie header value according to the rules in RFC 6265.
/// This function was adapted from `dart:io`.
List<Cookie> _parseCookieString(String s) {
  var cookies = <Cookie>[];

  int index = 0;

  bool done() => index == -1 || index == s.length;

  void skipWS() {
    while (!done()) {
      if (s[index] != " " && s[index] != "\t") return;
      index++;
    }
  }

  String parseName() {
    int start = index;
    while (!done()) {
      if (s[index] == " " || s[index] == "\t" || s[index] == "=") break;
      index++;
    }
    return s.substring(start, index);
  }

  String parseValue() {
    int start = index;
    while (!done()) {
      if (s[index] == " " || s[index] == "\t" || s[index] == ";") break;
      index++;
    }
    return s.substring(start, index);
  }

  bool expect(String expected) {
    if (done()) return false;
    if (s[index] != expected) return false;
    index++;
    return true;
  }

  while (!done()) {
    skipWS();
    if (done()) continue;
    String name = parseName();
    skipWS();
    if (!expect("=")) {
      index = s.indexOf(';', index);
      continue;
    }
    skipWS();
    String value = parseValue();
    try {
      cookies.add(Cookie(name, value));
    } catch (_) {
      // Skip it, invalid cookie data.
    }
    skipWS();
    if (done()) continue;
    if (!expect(";")) {
      index = s.indexOf(';', index);
      continue;
    }
  }

  return cookies;
}
