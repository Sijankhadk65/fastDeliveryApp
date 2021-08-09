library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fastdeliveryapp/src/models/fast_client.dart';
import '../models/order_ref.dart';
import '../models/rating.dart';
import '../models/user.dart';
import '../models/vendor.dart';

import './cart_items.dart';
import './online_order.dart';

part 'serializer.g.dart';

@SerializersFor(
  const [
    CartItem,
    OnlineOrder,
    User,
    Vendor,
    OrderRef,
    Rating,
    FastClient,
  ],
)
final Serializers serializers = _$serializers;
final jsonSerializer = (serializers.toBuilder()
      ..addPlugin(
        StandardJsonPlugin(),
      ))
    .build();
