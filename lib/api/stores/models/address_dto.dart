import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDto {
  const AddressDto(
      {required this.addressLine1,
      required this.addressLine2,
      required this.suburb,
      required this.state,
      required this.postcode,
      required this.country,
      required this.latitude,
      required this.longitude});

  @JsonKey(name: 'addressLine1')
  final String addressLine1;
  @JsonKey(name: 'addressLine2')
  final String addressLine2;
  @JsonKey(name: 'suburb')
  final String suburb;
  @JsonKey(name: 'state')
  final String state;
  @JsonKey(name: 'postcode')
  final String postcode;
  @JsonKey(name: 'country')
  final String country;
  @JsonKey(name: 'Latitude')
  final double latitude;
  @JsonKey(name: 'Longitude')
  final double longitude;

  double distanceInMeters(Position? position) {
    if (position == null) {
      return -1;
    }

    return Geolocator.distanceBetween(
        position.latitude, position.longitude, latitude, longitude);
  }

    static AddressDto fromJson(Map<String, dynamic> json) =>
    _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$AddressDtoToJson(this);
}