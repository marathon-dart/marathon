# Marathon Cookies

Marathon's cookie parser middleware for the Dart shelf ecosystem.
Reads cookies in request, sets cookies in response.

Adds a `CookieParser` instance to `request.context['cookies']` to help
manipulate cookies.

## Authorship

This project was originally authored by [Izolate](https://github.com/izolate). It was forked by the Marathon
organization, ported to null-safety, and migrated to the RFC 6265 specification (it was using RFC 2109 before
for adding responses, which is deprecated).

## Example

```dart
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_cookie/shelf_cookie.dart';

/// Handle a request that contains a `Cookie` header.
/// e.g. 'Cookie': 'ping=foo'
var handler = const Pipeline()
    // initialize cookie parser middleware
    .addMiddleware(cookieParser())
    .addHandler((req) async {
  CookieParser cookies = req.context['cookies'];

  // Retrieve request cookies.
  var reqCookie = cookies.get('ping')!;
  print(reqCookie.name); // foo

  // Clear cookies because Shelf currently only supports
  // a single `Set-Cookie` header in response.
  cookies.clear();

  // Create a cookie for response.
  var resCookie = cookies.set('pong', 'bar', secure: true);

  // Middleware will add `Set-Cookie` response header.
  // e.g. 'Set-Cookie': 'pong=bar; Secure; HttpOnly'
  return Response.ok('OK');
});
```
