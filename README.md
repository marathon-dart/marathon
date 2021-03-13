A framework and collection of packages for writing http servers, built on top of the shelf package.

This framework is intended to reduce the technical debt associated with server-side Dart
by relying on existing utilities where possible, and filling in the gaps with original code
and syntactic sugar where necessary.

This repository is a stub right now, as the project is still in the planning phase. We plan
to ship a preliminary alpha by the end of May, though this timeline is subject to change.

## Planned Features

The following features are planned for this framework. Most have been directly pulled from
popular libraries in other languages, such as Flask, Express, Django, etc.

#### Base
The "base" or skeleton of this library should expose an API by which both first-party and third-party
can hook into the server via middleware or handlers. An example of important middleware might be session
management or authenticators; given the dynamic nature of these tasks, we can't possibly encapsulate every
possibility in this library.

This API should integrate cleanly with [shelf][https://pub.dev/packages/shelf]. Shelf will handle the "dirty
work"; rewriting shelf's functionality in this library is transparently useless, since Google officially
maintains that library and it's relatively stable.

The base should also feature routing. Since the majority of people writing an http server need some form of
routing, it's reasonable to bundle it in the main library. Routing should use [shelf_router][https://pub.dev/packages/shelf_router], for
much the same reasons listed above for the main shelf package. This allows basic http path routing (e.g. 
exposing a different function for various paths) and path-based parameters.

An example syntax, using only the base package, might look like:

```dart
// in main.dart
import "package:marathon/marathon_base.dart";
import "service.dart";

void main (List<String> args) async {
  var router = Router(); // defined in shelf_router
  router.register(EchoService()); // extension method from Marathon, that (using reflection?) adds routes from EchoService to shelf_router.
  await io.serve(router.handler, 'localhost', 8080); // defined in shelf
}
```

```dart
// in service.dart
import "package:marathon/marathon_base.dart";

class EchoService extends PathHandler { // PathHandler is defined in marathon
  String get basePath => "/echo"; // This handler will handle requests starting with /echo
  
  // ResponseFunction is a convenience typedef for Response Function(Request).
  //
  // Marathon.handler is our "hook" here. We can override/replace it downstream to
  // inject resources, such as session id's, authenticated data, ORMs, whatever.
  ResponseFunction get name => Marathon.handler("/<name>", (Request r, String name) {
    return Response.ok('echo $name'); 
  } 
}
```

#### Rest of the features are under consideration...

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/marathon-dart/marathon/issues
