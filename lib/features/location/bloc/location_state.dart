part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.locationEnabled = false,
    this.hasPermission = false,
    this.isLocating = false,
    this.position,
    this.address,
  });

  final bool locationEnabled;
  final bool hasPermission;
  final bool isLocating;
  final Position? position;
  final Address? address;
  
  LocationState copyWith({
    bool? locationEnabled,
    bool? hasPermission,
    bool? isLocating,
    Position? position,
    Address? address,
  }) {
    return LocationState(
      locationEnabled: locationEnabled ?? this.locationEnabled,
      hasPermission: hasPermission ?? this.hasPermission,
      isLocating: isLocating ?? this.isLocating,
      position: position ?? this.position,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
    locationEnabled,
    hasPermission,
    isLocating,
    position,
    address
  ];
}
