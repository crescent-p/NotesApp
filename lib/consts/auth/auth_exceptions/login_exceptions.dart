//Login errors



class UserNotFoundAuthException implements Exception {}

class PasswordNotFoundAuthException implements Exception {}

//Registration Errors

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Generic Errors

class GenericAuthException implements Exception {}

class UserNotLoggedIn implements Exception{}