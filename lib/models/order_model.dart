import 'package:demoecommerceproduct/models/product/product_model.dart';

class OrderModel {
  List<ProductItem>? orderItems;
  String? id;
  String? userId;
  List<dynamic>? statuses;
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
    this.statuses,
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
          ? List<ProductItem>.from(
              json['orderItems'].map((x) => ProductItem.fromJson(x, true)))
          : [],
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      statuses:
          json['statuses'] != null ? List<dynamic>.from(json['statuses']) : [],
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
      "statuses": statuses ?? [],
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
