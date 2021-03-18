part of 'route_group.dart';

/// A representation of a handler for a specific route.
///
/// A typical RouteHandler declaration occurs in three steps:
/// 1. Instantiation.
/// 2. HTTP Method Specification
/// 3. Handler Specification
///
/// In the first step, you have to instantiate the RouteHandler:
/// ```dart
/// var myHandler = RouteHandler('my/path');
/// ```
///
/// In the second step, you have to specify the method(s) that this handler
/// will respond to:
/// ```dart
/// var myHandler1 = RouteHandler('my/path').get;
/// var myHandler2 = RouteHandler('my/other/path').get.post;
/// var myHandler3 = RouteHandler('my/third/path').all;
/// ```
/// In the above example, the first handler will respond to GET requests made to
/// my/path. The second will respond to GET and POST requests made to
/// my/other/path. The third will respond to all requests made to my/third/path.
///
/// Finally, we have the "handling" logic. For example:
/// ```dart
/// // using the first handler from above
/// var myHandler1 = RouteHandler('my/path').get.handle((_) => Response.ok('yay!'));
/// ```
/// This final example is a complete RouteHandler. If you nest it in a class
/// that extends [RouteGroup] and register that class with a router, it will
/// become part of your application. See [RouteGroup]'s documentation for more.
// TODO: documentation about path parameters.
class RouteHandler {
  String path;
  final Set<_HttpMethod> _methods = {};
  Function? _handler;
  bool isComplete = false;

  /// Construct a new RouteHandler from a path. You can then use getters to specify
  /// what HTTP methods will be handled, and then call the [handle] method to
  /// specify what the handling action is.
  RouteHandler(this.path);

  /// Specify that this RouteHandler will handle the CONNECT method. Returns
  /// this RouteHandler with a slightly modified internal state.
  RouteHandler get connect => this.._methods.add(_HttpMethod.connect);

  /// Specify that this RouteHandler will handle the GET method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get get => this.._methods.add(_HttpMethod.get);

  /// Specify that this RouteHandler will handle the HEAD method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get head => this.._methods.add(_HttpMethod.head);

  /// Specify that this RouteHandler will handle the MOUNT method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get mount => this.._methods.add(_HttpMethod.mount);

  /// Specify that this RouteHandler will handle the PATCH method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get patch => this.._methods.add(_HttpMethod.patch);

  /// Specify that this RouteHandler will handle the POST method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get post => this.._methods.add(_HttpMethod.post);

  /// Specify that this RouteHandler will handle the PUT method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get put => this.._methods.add(_HttpMethod.put);

  /// Specify that this RouteHandler will handle the OPTIONS method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get options => this.._methods.add(_HttpMethod.options);

  /// Specify that this RouteHandler will handle the TRACE method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get trace => this.._methods.add(_HttpMethod.trace);

  /// Specify that this RouteHandler will handle the TRACE method. Returns this
  /// RouteHandler with a slightly modified internal state.
  RouteHandler get all => this.._methods.addAll(_HttpMethod.values);

  /// After specifying the HTTP methods you want using getters, adds
  /// the Function handler for all those HTTP methods.
  RouteHandler handle(Function handler) {
    if (_methods.isEmpty) {
      throw StateError('you must specify target methods before a handler');
    }
    isComplete = true;
    return this.._handler = handler;
  }
}

enum _HttpMethod {
  connect,
  get,
  head,
  mount,
  patch,
  post,
  put,
  options,
  trace,
}
