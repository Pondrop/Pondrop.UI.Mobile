import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocode/geocode.dart';
import 'package:pondrop/app/app.dart';
import 'package:pondrop/bootstrap.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  final authenticationRepository = AuthenticationRepository();
  final locationRepository = LocationRepository(geoCode: GeoCode());
  final userRepository = UserRepository(secureStorage: const FlutterSecureStorage());
  
  bootstrap(() => App(
    authenticationRepository: authenticationRepository,
    locationRepository: locationRepository,
    userRepository: userRepository,
  ));
}
