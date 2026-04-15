abstract class AuthState {}
class Idle extends AuthState {}
class Loading extends AuthState {}

class Success<T> extends AuthState {
  final T data;
  Success(this.data);
}

class Error extends AuthState {
  final String message;
  Error(this.message);
}

class Cancelled extends AuthState {}