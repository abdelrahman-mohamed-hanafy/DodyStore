class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});

  bool get isSuccess => error == null;
}