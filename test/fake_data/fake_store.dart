import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeStore {
  static Store fakeStore() {
    return Store(
      id: const Uuid().v4(),
      provider: 'Coles',
      name: 'Flutter',
      displayName: 'Coles - Flutter',
      address: '123 Street, Kingdom',
      latitude: 0,
      longitude: 0,
      lastKnowDistanceMetres: 150
    );
  }
}
