import 'package:marathon/marathon.dart';
import 'package:marathon_cookies/marathon_cookies.dart';

// To test the example:
//  Run this Dart file
//  open up a browser and load http://localhost:8080
//  Inspect, open up Application/cookies
//  Add a cookie named "ping" with any value
//  Reload the page and check whether "ping" has been set to "bar"
void main() {
  /// Request contains cookie header.
  /// e.g. 'cookie': 'ping=foo'
  var handler =
      const Pipeline().addMiddleware(cookieParser()).addHandler((req) async {
    CookieParser cookies = req.context['cookies'] as CookieParser;
    if (cookies.get('ping') != null) {
      cookies.set('ping', 'bar');
    }

    // Response will set cookie header.
    // e.g. 'set-cookie': 'pong=bar; Secure; HttpOnly'
    return Response.ok('check your cookies');
  });

  serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
