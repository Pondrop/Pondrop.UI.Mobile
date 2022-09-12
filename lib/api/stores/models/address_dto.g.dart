// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String,
      suburb: json['suburb'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      country: json['country'] as String,
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'suburb': instance.suburb,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
    };
