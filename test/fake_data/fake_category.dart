import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeCategory {
  static Category fakeCategory() {
    return Category(
      id: const Uuid().v4(),
      name: 'Mock Category',
    );
  }
}
