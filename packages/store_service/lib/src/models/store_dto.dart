import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_dto.g.dart';

@JsonSerializable()
class StoreDto {
  const StoreDto({
    required this.searchScore,
    required this.id,
    required this.storeNo,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.address,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.openHours,
    required this.url,
    required this.provider,
    required this.updatedDate,
    required this.country,
    required this.status,
    required this.directionUrl,
    required this.banner,
    required this.stockTicker,
    required this.fax,
    required this.email,
    required this.locations,
    required this.keyphrases,
  });

  @JsonKey(name: '@search.score')
  final double searchScore;
  @JsonKey(name: 'Id')
  final String id;
  @JsonKey(name: 'StoreNo')
  final int? storeNo;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Latitude')
  final double latitude;
  @JsonKey(name: 'Longitude')
  final double longitude;
  @JsonKey(name: 'Location')
  final String? location;
  @JsonKey(name: 'Address')
  final String address;
  @JsonKey(name: 'Street')
  final String? street;
  @JsonKey(name: 'City')
  final String? city;
  @JsonKey(name: 'State')
  final String? state;
  @JsonKey(name: 'Zip_Code')
  final String? zipCode;
  @JsonKey(name: 'Phone')
  final String? phone;
  @JsonKey(name: 'OpenHours')
  final String? openHours;
  @JsonKey(name: 'URL')
  final String? url;
  @JsonKey(name: 'Provider')
  final String? provider;
  @JsonKey(name: 'UpdatedDate')
  final DateTime updatedDate;
  @JsonKey(name: 'Country')
  final String? country;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'DirectionURL')
  final String? directionUrl;
  @JsonKey(name: 'Banner')
  final String? banner;
  @JsonKey(name: 'StockTicker')
  final String? stockTicker;
  @JsonKey(name: 'Fax')
  final String? fax;
  @JsonKey(name: 'Email')
  final String? email;
  @JsonKey(name: 'locations')
  final List<String>? locations;
  @JsonKey(name: 'keyphrases')
  final List<String>? keyphrases;

  double distanceInMeters(Position? position) {
    if (position == null) {
      return -1;
    }

    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      latitude,
      longitude);
  }

  static StoreDto fromJson(Map<String, dynamic> json) =>
    _$StoreDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$StoreDtoToJson(this);
}
