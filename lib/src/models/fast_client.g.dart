// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast_client.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FastClient> _$fastClientSerializer = new _$FastClientSerializer();

class _$FastClientSerializer implements StructuredSerializer<FastClient> {
  @override
  final Iterable<Type> types = const [FastClient, _$FastClient];
  @override
  final String wireName = 'FastClient';

  @override
  Iterable<Object> serialize(Serializers serializers, FastClient object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.photoURI != null) {
      result
        ..add('photoURI')
        ..add(serializers.serialize(object.photoURI,
            specifiedType: const FullType(String)));
    }
    if (object.phoneNumber != null) {
      result
        ..add('phoneNumber')
        ..add(serializers.serialize(object.phoneNumber,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  FastClient deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FastClientBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'photoURI':
          result.photoURI = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$FastClient extends FastClient {
  @override
  final String email;
  @override
  final String name;
  @override
  final String photoURI;
  @override
  final int phoneNumber;

  factory _$FastClient([void Function(FastClientBuilder) updates]) =>
      (new FastClientBuilder()..update(updates)).build();

  _$FastClient._({this.email, this.name, this.photoURI, this.phoneNumber})
      : super._();

  @override
  FastClient rebuild(void Function(FastClientBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FastClientBuilder toBuilder() => new FastClientBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FastClient &&
        email == other.email &&
        name == other.name &&
        photoURI == other.photoURI &&
        phoneNumber == other.phoneNumber;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, email.hashCode), name.hashCode), photoURI.hashCode),
        phoneNumber.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FastClient')
          ..add('email', email)
          ..add('name', name)
          ..add('photoURI', photoURI)
          ..add('phoneNumber', phoneNumber))
        .toString();
  }
}

class FastClientBuilder implements Builder<FastClient, FastClientBuilder> {
  _$FastClient _$v;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _photoURI;
  String get photoURI => _$this._photoURI;
  set photoURI(String photoURI) => _$this._photoURI = photoURI;

  int _phoneNumber;
  int get phoneNumber => _$this._phoneNumber;
  set phoneNumber(int phoneNumber) => _$this._phoneNumber = phoneNumber;

  FastClientBuilder();

  FastClientBuilder get _$this {
    if (_$v != null) {
      _email = _$v.email;
      _name = _$v.name;
      _photoURI = _$v.photoURI;
      _phoneNumber = _$v.phoneNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FastClient other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FastClient;
  }

  @override
  void update(void Function(FastClientBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FastClient build() {
    final _$result = _$v ??
        new _$FastClient._(
            email: email,
            name: name,
            photoURI: photoURI,
            phoneNumber: phoneNumber);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
