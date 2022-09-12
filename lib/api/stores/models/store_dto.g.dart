// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => StoreDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      externalReferenceId: json['externalReferenceId'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      openHours: json['openHours'] as String?,
      retailerId: json['retailerId'] as String?,
      retailer: json['retailer'] == null
          ? null
          : RetailerDto.fromJson(json['retailer'] as Map<String, dynamic>),
      storeTypeId: json['storeTypeId'] as String?,
      updatedDate: DateTime.parse(json['updatedDate'] as String),
      directionUrl: json['directionURL'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreDtoToJson(StoreDto instance) => <String, dynamic>{
      '@search.score': instance.searchScore,
      'id': instance.id,
      'externalReferenceId': instance.externalReferenceId,
      'name': instance.name,
      'status': instance.status,
      'phone': instance.phone,
      'openHours': instance.openHours,
      'retailerId': instance.retailerId,
      'retailer': instance.retailer,
      'storeTypeId': instance.storeTypeId,
      'updatedDate': instance.updatedDate.toIso8601String(),
      'directionURL': instance.directionUrl,
      'email': instance.email,
      'addresses': instance.addresses,
    };
