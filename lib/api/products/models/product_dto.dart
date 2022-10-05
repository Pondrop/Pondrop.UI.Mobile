import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';
part 'product_search_result_dto.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto(
      {required this.searchScore,
      required this.externalReferenceId,
      required this.uniqueBarcode,
      required this.gln,
      required this.tm,
      required this.product,
      required this.variant,
      required this.altName,
      required this.shortDescription,
      required this.netContent,
      required this.netContentUom,
      required this.possibleCategories,
      required this.childBarcode,
      required this.childQuantity,
      required this.brand,
      required this.company,
      required this.updatedUtc,});

  @JsonKey(name: '@search.score')
  final double searchScore;
  @JsonKey(name: 'externalReferenceId')
  final String externalReferenceId;
  @JsonKey(name: 'uniqueBarcode')
  final String uniqueBarcode;
  @JsonKey(name: 'gln')
  final String gln;
  @JsonKey(name: 'tm')
  final int tm;
  @JsonKey(name: 'product')
  final String product;
  @JsonKey(name: 'variant')
  final String? variant;
  @JsonKey(name: 'altName')
  final String? altName;
  @JsonKey(name: 'shortDescription')
  final String? shortDescription;  
  @JsonKey(name: 'netContent')
  final double netContent;
  @JsonKey(name: 'netContentUom')
  final String? netContentUom;
  @JsonKey(name: 'possibleCategories')
  final String? possibleCategories;
  @JsonKey(name: 'childbarcode')
  final int? childBarcode;
  @JsonKey(name: 'childQuantity')
  final double? childQuantity;
  @JsonKey(name: 'brand')
  final String? brand;
  @JsonKey(name: 'company')
  final String? company;

  @JsonKey(name: 'updatedUtc')
  final DateTime? updatedUtc;

  static ProductDto fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
