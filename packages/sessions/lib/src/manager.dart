import 'package:marathon/marathon.dart';
import 'package:marathon_sessions/src/uuid.dart';

import 'store.dart';

class Sessions {
  SessionStore store;

  String Function() genID;

  /// A property defining whether the cookies used will be limited to only http.
  /// By default, this is true.
  bool cookieHttpOnly;

  /// A property defining whether the cookies used will be limited to only
  /// secure communications (https). By default, this is false; however, it is
  /// highly recommended for production environments..
  bool cookieSecure;

  Duration cookieMaxAge;

  Sessions(
      {required this.store,
      this.cookieHttpOnly = true,
      this.cookieMaxAge = const Duration(minutes: 30),
      this.cookieSecure = false,
      this.genID = genUUID});

  Middleware get manager {
    return createMiddleware();
  }
}
