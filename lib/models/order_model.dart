import 'package:demoecommerceproduct/models/product/product_model.dart';

class OrderModel {
  List<OrderItem>? orderItems;
  String? id;
  String? userId;
  // List<dynamic>? statuses;
  String? currentStatus;
  num? totalCost;
  num? totalSelling;
  num? profitMargin;
  num? profit;
  num? discount;
  num? deliveryCharge;
  String? couponCode;
  String? createdAt;
  String? updatedAt;

  OrderModel({
    this.orderItems,
    this.id,
    this.userId,
    this.currentStatus,
    // this.statuses,
    this.totalCost,
    this.totalSelling,
    this.profitMargin,
    this.profit,
    this.discount,
    this.deliveryCharge,
    this.couponCode,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderItems: json['orderItems'] != null
          ? List<OrderItem>.from(
              json['orderItems'].map((x) => OrderItem.fromJson(x)))
          : [],
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      currentStatus: json['currentStatus'] ?? "",
      // statuses:
      //     json['statuses'] != null ? List<dynamic>.from(json['statuses']) : [],
      totalCost: json['totalCost'] ?? 0,
      totalSelling: json['totalSelling'] ?? 0,
      profitMargin: json['profitMargin'] ?? 0,
      profit: json['profit'] ?? 0,
      discount: json['discount'] ?? 0,
      deliveryCharge: json['deliveryCharge'] ?? 0,
      couponCode: json['couponCode'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderItems": orderItems != null
          ? List<dynamic>.from(orderItems!.map((x) => x.toJson()))
          : [],
      "id": id,

      "userId": userId,
      // "statuses": statuses ?? [],
      "totalCost": totalCost,
      "totalSelling": totalSelling,
      "profitMargin": profitMargin,
      "profit": profit,
      "discount": discount,
      "deliveryCharge": deliveryCharge,
      "couponCode": couponCode,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

class OrderItem {
  final String? id;
  final String? orderId;
  final String? productId;
  final String? variantId;
  final String? productName;
  final String? variantName;
  final int? quantity;
  final double? unitPrice;
  final double? discountedPrice;
  final String? createdAt;
  final String? updatedAt;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.variantId,
    this.productName,
    this.variantName,
    this.quantity,
    this.unitPrice,
    this.discountedPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? "",
      orderId: json['orderId'] ?? "",
      productId: json['productId'] ?? "",
      variantId: json['variantId'] ?? "",
      productName: json['productName'] ?? "",
      variantName: json['variantName'] ?? "",
      quantity: json['quantity'] ?? 0,
      unitPrice:
          (json['unitPrice'] != null) ? json['unitPrice'].toDouble() : 0.0,
      discountedPrice: (json['discountedPrice'] != null)
          ? json['discountedPrice'].toDouble()
          : 0.0,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'variantId': variantId,
      'productName': productName,
      'variantName': variantName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discountedPrice': discountedPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
