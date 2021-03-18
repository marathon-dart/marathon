// in service.dart
import 'package:marathon/marathon.dart';

// RouteGroup is an abstract class defined in marathon.
//
// It should have a abstract property:
//   List<Handler> get routes
// Which tells the register method which routes to add.
class EchoService extends RouteGroup {
  // This handler will handle requests starting with /echo.
  @override
  String get basePath => '/echo';

  var getName =
      RouteHandler('/<name>').get.post.handle((Request r, String name) {
    return Response.ok('echo $name');
  });
}
