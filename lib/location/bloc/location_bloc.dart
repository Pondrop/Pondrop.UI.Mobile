import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/location/repositories/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc
    extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const LocationState()) {
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<LocationPositionUpdateRequested>(_onLocationPositionUpdateRequested);
  }

  final LocationRepository _locationRepository;

  Future<void> _onLocationPermissionRequested(
    LocationPermissionRequested event,
    Emitter<LocationState> emit,
  ) async {
    final enabled = await _locationRepository.isLocationServiceEnabled();
    final hasPermission = 
      enabled &&
      await _locationRepository.checkAndRequestPermissions();

    emit(state.copyWith(
      locationEnabled: enabled,
      hasPermission: hasPermission,
    ));
  }

  Future<void> _onLocationPositionUpdateRequested(
    LocationPositionUpdateRequested event,
    Emitter<LocationState> emit,
  ) async {
    var enabled = state.locationEnabled;
    var hasPermission = state.hasPermission;

    if (!enabled || !hasPermission) {
      enabled = await _locationRepository.isLocationServiceEnabled();
      hasPermission = 
        enabled &&
        await _locationRepository.checkAndRequestPermissions();

      if (enabled && hasPermission) {
        emit(state.copyWith(
          isLocating: true
        ));

        try {
          final position = await _locationRepository.getCurrentPosition();
          final address = position != null
            ? await _locationRepository.getAddress(position)
            : null;

          emit(state.copyWith(
            locationEnabled: enabled,
            hasPermission: hasPermission,
            isLocating: false,
            position: position,
            address: address,
          ));
        }
        catch (_) {
          emit(state.copyWith(
            isLocating: false,
          ));
        }
      }
    }
  }
}
