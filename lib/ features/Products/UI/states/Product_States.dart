abstract class ProductStates {}
class ProductIdle extends ProductStates {}
class ProductLoading extends ProductStates {}
class ProductSuccess extends ProductStates {
  final String message;
  ProductSuccess(this.message);
}
class ProductError extends ProductStates {
  final String message;
  ProductError(this.message);
}