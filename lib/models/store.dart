import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Store extends Equatable {
  const Store(
      {required this.id,
      required this.provider,
      required this.name,
      required this.displayName,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.lastKnowDistanceMetres});

  final String id;
  final String provider;
  final String name;
  final String displayName;
  final String address;
  final double latitude;
  final double longitude;
  final double lastKnowDistanceMetres;

  String getDistanceDisplayString() {
    if (lastKnowDistanceMetres < 0) {
      return '';
    }

    if (lastKnowDistanceMetres >= 1000000) {
      return '${NumberFormat('#,##0').format(lastKnowDistanceMetres / 1000)}km';
    } else {
      return lastKnowDistanceMetres >= 1000
          ? '${NumberFormat('#,##0.0').format(lastKnowDistanceMetres / 1000)}km'
          : '${lastKnowDistanceMetres.toStringAsFixed(0)}m';
    }
  }

  @override
  List<Object> get props => [
        id,
        provider,
        name,
        address,
        latitude,
        longitude,
        lastKnowDistanceMetres
      ];
}
