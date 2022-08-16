import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class Store extends Equatable {
  const Store(
      {required this.id,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.distanceFromLocation});

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceFromLocation;

   double convertDistanceToKM(){
      return double.parse((distanceFromLocation / 1000).toStringAsFixed(2));
    }

  @override
  List<Object> get props => [id, name, address, latitude, longitude,distanceFromLocation];
}
