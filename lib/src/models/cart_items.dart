import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import './serializer.dart';

part 'cart_items.g.dart';

abstract class CartItem implements Built<CartItem, CartItemBuilder> {
  @nullable
  String get name;
  @nullable
  double get price;
  @nullable
  double get totalPrice;
  @nullable
  double get quantity;
  CartItem._();
  factory CartItem([updates(CartItemBuilder b)]) = _$CartItem;
  static Serializer<CartItem> get serializer => _$cartItemSerializer;
  Map<String, dynamic> toJson() => {
        "name": this.name,
        "price": this.price,
        "quantity": this.quantity,
        "totalPrice": this.totalPrice
      };
}

CartItem parseToCartItem(Map<String, dynamic> json) {
  return jsonSerializer.deserializeWith(CartItem.serializer, json);
}
