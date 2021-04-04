import 'package:shelf/shelf.dart' as shelf;
import 'package:marathon_models/marathon_models.dart';

extension on shelf.Request {
  // gets the user object from the request object.
  // User object is stored in the request['maraton.context'].
  // BaseUser can be either a User or an Anonymous User.
  // See package:marathon_models/marathon_models.dart for more info on BaseUser.
  // ignore: unused_element
  BaseUser get user => _getUser(this);
  // ignore: unused_element
  void setUser(BaseUser user) {
    context['marathon.user'] = user;
  }
}

BaseUser _getUser(shelf.Request request) {
  return request.context['marathon.user'] as BaseUser;
}
