abstract class HomeStates {}

class Idle extends HomeStates {}

class Loading extends HomeStates {}

class Success<T> extends HomeStates {
  final T data;
  Success(this.data);
}

class HomeError extends HomeStates {
  final String message;
  HomeError(this.message);
}