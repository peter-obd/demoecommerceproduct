class StockCheckItem {
  final String productId;
  final String? variantId;
  final int quantity;

  StockCheckItem({
    required this.productId,
    this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'variantId': variantId,
        'quantity': quantity,
      };
}

class UnavailableItem {
  final String productId;
  final String? variantId;
  final int quantity;

  UnavailableItem({
    required this.productId,
    this.variantId,
    required this.quantity,
  });

  factory UnavailableItem.fromJson(Map<String, dynamic> json) {
    return UnavailableItem(
      productId: json['productId'],
      variantId: json['variantId'],
      quantity: json['quantity'],
    );
  }

  bool get isOutOfStock => quantity == 0;
  bool get hasLimitedStock => quantity > 0;
}

class StockAvailabilityResponse {
  final bool allAvailable;
  final List<UnavailableItem> unavailableItems;

  StockAvailabilityResponse({
    required this.allAvailable,
    required this.unavailableItems,
  });

  factory StockAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return StockAvailabilityResponse(
      allAvailable: json['allAvailable'],
      unavailableItems: (json['unavailableItems'] as List)
          .map((item) => UnavailableItem.fromJson(item))
          .toList(),
    );
  }

  List<UnavailableItem> get outOfStockItems =>
      unavailableItems.where((item) => item.isOutOfStock).toList();

  List<UnavailableItem> get limitedStockItems =>
      unavailableItems.where((item) => item.hasLimitedStock).toList();

  bool get hasOutOfStockItems => outOfStockItems.isNotEmpty;
  bool get hasLimitedStockItems => limitedStockItems.isNotEmpty;
}
