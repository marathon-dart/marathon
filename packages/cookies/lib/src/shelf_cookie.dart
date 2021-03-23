import 'dart:async';
import 'dart:io';

import 'package:marathon/marathon.dart';

import 'cookie_parser.dart';

/// Creates a Shelf [Middleware] to parse cookies.
///
/// Adds a [CookieParser] instance to `request.context['cookies']`,
/// with convenience methods to manipulate cookies in request handlers.
///
/// Adds a `Set-Cookie` HTTP header to the response for each cookie currently
/// present in the parser.
Middleware cookieParser() {
  return (Handler innerHandler) {
    return (Request request) {
      var parser = CookieParser.fromHeader(request.headers);
      return Future.sync(() {
        return innerHandler(
          request.change(context: {'cookies': parser}),
        );
      }).then((Response response) {
        if (parser.isEmpty) {
          return response;
        }
        return response.change(
          headers: {
            for (var cookie in parser.cookies) HttpHeaders.setCookieHeader: cookie.toString()
          },
        );
      }, onError: (error, StackTrace stackTrace) {
        throw error;
      });
    };
  };
}
