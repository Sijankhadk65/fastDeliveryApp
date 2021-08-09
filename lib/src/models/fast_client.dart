import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../models/serializer.dart';

part 'fast_client.g.dart';

abstract class FastClient implements Built<FastClient, FastClientBuilder> {
  @nullable
  String get email;
  @nullable
  String get name;
  @nullable
  String get photoURI;
  @nullable
  int get phoneNumber;

  factory FastClient([void Function(FastClientBuilder) updates]) = _$FastClient;
  FastClient._();
  static Serializer<FastClient> get serializer => _$fastClientSerializer;
}

FastClient parseJsonToFastClient(Map<String, dynamic> json) {
  return jsonSerializer.deserializeWith(FastClient.serializer, json);
}

Map<String, dynamic> convertFastClientToJson(FastClient user) => {
      "name": user.name,
      "email": user.email,
      "photoUrl": user.photoURI,
      "phoneNumber": user.phoneNumber,
    };
