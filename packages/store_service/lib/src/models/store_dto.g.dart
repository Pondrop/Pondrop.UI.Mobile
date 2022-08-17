// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => StoreDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      id: json['Id'] as String,
      storeNo: json['StoreNo'] as int?,
      name: json['Name'] as String,
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      location: json['Location'] as String?,
      address: json['Address'] as String,
      street: json['Street'] as String?,
      city: json['City'] as String?,
      state: json['State'] as String?,
      zipCode: json['Zip_Code'] as String?,
      phone: json['Phone'] as String?,
      openHours: json['OpenHours'] as String?,
      url: json['URL'] as String?,
      provider: json['Provider'] as String?,
      updatedDate: DateTime.parse(json['UpdatedDate'] as String),
      country: json['Country'] as String?,
      status: json['Status'] as String?,
      directionUrl: json['DirectionURL'] as String?,
      banner: json['Banner'] as String?,
      stockTicker: json['StockTicker'] as String?,
      fax: json['Fax'] as String?,
      email: json['Email'] as String?,
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      keyphrases: (json['keyphrases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StoreDtoToJson(StoreDto instance) => <String, dynamic>{
      '@search.score': instance.searchScore,
      'Id': instance.id,
      'StoreNo': instance.storeNo,
      'Name': instance.name,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Location': instance.location,
      'Address': instance.address,
      'Street': instance.street,
      'City': instance.city,
      'State': instance.state,
      'Zip_Code': instance.zipCode,
      'Phone': instance.phone,
      'OpenHours': instance.openHours,
      'URL': instance.url,
      'Provider': instance.provider,
      'UpdatedDate': instance.updatedDate.toIso8601String(),
      'Country': instance.country,
      'Status': instance.status,
      'DirectionURL': instance.directionUrl,
      'Banner': instance.banner,
      'StockTicker': instance.stockTicker,
      'Fax': instance.fax,
      'Email': instance.email,
      'locations': instance.locations,
      'keyphrases': instance.keyphrases,
    };
