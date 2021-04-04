abstract class BaseUser {
  String _username;
  String _email;
  String _firstName;
  String _password; // Passwords would hashed and stored.
  String _lastName;
  DateTime _lastLogin;
  bool _isAnonymous;
  DateTime _registered;

  String get username;
  String get firsName;
  String get fullName;
  String get email;
  DateTime get lastLogin;
  DateTime get registed;
  bool get isAnonymous;

  bool verifyUser(String password);
}

class User extends BaseUser {
  @override
  String get username => _username;
  @override
  String get firsName => _firstName;
  @override
  String get fullName => '$_firstName _$_lastName';
  @override
  String get email => _email;
  @override
  DateTime get lastLogin => _lastLogin;
  @override
  DateTime get registed => _registered;
  @override
  bool get isAnonymous => false;

  @override
  bool verifyUser(String password) {
    return password == _password;
  }
}

class AnonymousUser extends BaseUser {
  @override
  String get email => throw AnonymousUserError();
  @override
  String get firsName => throw AnonymousUserError();
  @override
  String get fullName => throw AnonymousUserError();
  @override
  DateTime get lastLogin => throw AnonymousUserError();
  @override
  DateTime get registed => throw AnonymousUserError();
  @override
  String get username => throw AnonymousUserError();
  @override
  bool get isAnonymous => true;
  @override
  bool verifyUser(String password) {
    throw AnonymousUserError();
  }
}

class AnonymousUserError extends Error {
  final String message;
  AnonymousUserError([this.message]);
  @override
  String toString() {
    var message = this.message;
    return (message != null)
        ? 'AnonymousUserError: $message'
        : 'AnonymousUserError';
  }
}
