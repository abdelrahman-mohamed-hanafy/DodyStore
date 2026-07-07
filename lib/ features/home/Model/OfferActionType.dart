enum OfferActionType {
  none,
  product,
  category,
  offers,
}

extension OfferActionTypeExtension on OfferActionType {
  static OfferActionType fromString(String? value) {
    switch (value) {
      case 'product':
        return OfferActionType.product;
      case 'category':
        return OfferActionType.category;
      case 'offers':
        return OfferActionType.offers;
      default:
        return OfferActionType.none;
    }
  }

  String get value {
    switch (this) {
      case OfferActionType.product:
        return 'product';
      case OfferActionType.category:
        return 'category';
      case OfferActionType.offers:
        return 'offers';
      case OfferActionType.none:
        return 'none';
    }
  }
}