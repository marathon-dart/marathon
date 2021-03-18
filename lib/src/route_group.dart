library routes;

import 'dart:mirrors';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

part 'route.dart';

/// A class that encapsulates functionality for a group of related routes. It
/// also handles registering each route and their logic with a Router.
///
/// To use this class, extend it and implement your handlers. Those handlers
/// should be defined as top-level instance variables, like:
/// ```dart
/// class SubClassOfRouteGroup extends RouteGroup {
///   RouteHandler handler1 = ...;
/// }
/// ```
/// See [RouteHandler] for more information on implementing these handlers.
///
/// Then, you can can register your child class with the router:
/// ```dart
/// // in main.dart
/// import "package:marathon/marathon.dart";
/// import "service.dart";
///
/// void main (List<String> args) async {
///   var router = Router();
///   router.register(SubClassOfRouteGroup());
///   await serve(router.handler, 'localhost', 8080);
/// }
/// ```
/// Please note that, when you register the child class with the router, EVERY
/// instance variable with the type RouteHandler will be registered. This is an
/// unavoidable circumstance of using reflection to process the registration.
abstract class RouteGroup {
  /// If every route in this RouteGroup starts with a certain prefix, then you
  /// can override this getter and set it to give back the prefix. Then, when
  /// specifying other routes in this group, you can just leave that prefix off
  /// the front of the path; it will be accounted for here.
  String get basePath => '';

  RouteGroup();
}

extension RouteGroupRegister on Router {
  /// Registers your RouteGroup subclass with this router:
  /// ```dart
  /// // in main.dart
  /// import "package:marathon/marathon.dart";
  /// import "service.dart";
  ///
  /// void main (List<String> args) async {
  ///   var router = Router();
  ///   router.register(SubClassOfRouteGroup());
  ///   await serve(router.handler, 'localhost', 8080);
  /// }
  /// ```
  // TODO: handle Middleware
  void register(RouteGroup group) {
    // use reflection to find each member
    var groupReflector = reflect(group);
    var typeReflector = groupReflector.type;
    var members = typeReflector.instanceMembers;

    // iterate through members; if the member isn't a RouteHandler, skip to the
    // next member. If the member IS a RouteHandler, process it and add it to
    // this Router.
    for (var member in members.entries) {
      if (!member.value.isGetter ||
          !member.value.returnType.isAssignableTo(reflectType(RouteHandler))) {
        continue;
      } else {
        // find the handler object on the reflector
        var route =
            groupReflector.getField(member.key).reflectee as RouteHandler;

        // Add each HTTP method supported by this handler
        for (var httpMethod in route._methods) {
          var verb = httpMethod.toString().split('.')[1];
          if (route._handler == null) {
            throw ArgumentError(
                'you have a RouteHandler with no handling logic in your client class.');
          }
          add(verb, group.basePath + route.path, route._handler!);
        }
      }
    }
  }
}
