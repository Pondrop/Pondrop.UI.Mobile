import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';

class Store extends Equatable{
  const Store({required this.id, required this.name, required this.address});

  final String id;
  final String name;
  final String address;
  // final Position location;

  @override
  List<Object> get props => [id, name, address,];
}