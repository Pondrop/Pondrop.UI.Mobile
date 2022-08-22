import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocode/geocode.dart';
import 'package:pondrop/app/app.dart';
import 'package:pondrop/bootstrap.dart';
import 'package:pondrop/repositories/repositories.dart';

void main() {
  final locationRepository = LocationRepository(geoCode: GeoCode());
  final userRepository = UserRepository(secureStorage: const FlutterSecureStorage());
  final storeRepository = StoreRepository();
  final authenticationRepository = AuthenticationRepository(userRepository: userRepository);
  
  bootstrap(() => App(
    authenticationRepository: authenticationRepository,
    locationRepository: locationRepository,
    userRepository: userRepository,
    storeRepository: storeRepository
  ));
}
