abstract class BaseUser {
  late String _username;
  String? _email;
  String? _firstName;
  late String _password; // Passwords would hashed and stored.
  String? _lastName;
  DateTime? _lastLogin;
  late bool _isAnonymous;
  late DateTime _registered;

  String get username;
  String? get firstName;
  String? get fullName;
  String? get email;
  DateTime? get lastLogin;
  DateTime get registed;
  bool get isAnonymous;

  bool verifyUser(String password);
}

class User extends BaseUser {
  @override
  String get username => _username;

  @override
  String? get email => _email;
  @override
  String? get firstName => _firstName;
  @override
  String? get fullName {
    _lastName ??= ' ';
    if (_firstName == null) {
      return null;
    }
    return '$_firstName + $_lastName';
  }

  @override
  DateTime? get lastLogin => _lastLogin;
  @override
  DateTime get registed => _registered;
  @override
  bool get isAnonymous => _isAnonymous;

  @override
  bool verifyUser(String password) {
    return password == _password;
  }
}

class AnonymousUser extends BaseUser {
  @override
  String get email => throw AnonymousUserError();
  @override
  String get firstName => throw AnonymousUserError();
  @override
  String get fullName => throw AnonymousUserError();
  @override
  DateTime get lastLogin => throw AnonymousUserError();
  @override
  DateTime get registed => throw AnonymousUserError();
  @override
  String get username => throw AnonymousUserError();
  @override
  bool get isAnonymous => _isAnonymous;
  @override
  bool verifyUser(String password) {
    throw AnonymousUserError();
  }
}

class AnonymousUserError extends Error {
  final String? message;
  AnonymousUserError([this.message]);
  @override
  String toString() {
    var message = this.message;
    return (message != null)
        ? 'AnonymousUserError: $message'
        : 'AnonymousUserError';
  }
}
