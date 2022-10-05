// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      externalReferenceId: json['externalReferenceId'] as String,
      uniqueBarcode: json['uniqueBarcode'] as String,
      gln: json['gln'] as String,
      tm: json['tm'] as int,
      product: json['product'] as String,
      variant: json['variant'] as String?,
      altName: json['altName'] as String?,
      shortDescription: json['shortDescription'] as String?,
      netContent: (json['netContent'] as num).toDouble(),
      netContentUom: json['netContentUom'] as String?,
      possibleCategories: json['possibleCategories'] as String?,
      childBarcode: json['childbarcode'] as int?,
      childQuantity: (json['childQuantity'] as num?)?.toDouble(),
      brand: json['brand'] as String?,
      company: json['company'] as String?,
      updatedUtc: json['updatedUtc'] == null
          ? null
          : DateTime.parse(json['updatedUtc'] as String),
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      '@search.score': instance.searchScore,
      'externalReferenceId': instance.externalReferenceId,
      'uniqueBarcode': instance.uniqueBarcode,
      'gln': instance.gln,
      'tm': instance.tm,
      'product': instance.product,
      'variant': instance.variant,
      'altName': instance.altName,
      'shortDescription': instance.shortDescription,
      'netContent': instance.netContent,
      'netContentUom': instance.netContentUom,
      'possibleCategories': instance.possibleCategories,
      'childbarcode': instance.childBarcode,
      'childQuantity': instance.childQuantity,
      'brand': instance.brand,
      'company': instance.company,
      'updatedUtc': instance.updatedUtc?.toIso8601String(),
    };
