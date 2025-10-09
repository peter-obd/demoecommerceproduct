class OnCheckoutOrderProductModel {
  String? productId;
  String? variantId;
  int? quantity;
  OnCheckoutOrderProductModel({
    this.productId,
    this.variantId,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
    };
  }
}
