import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeProduct {
  static Product fakeProduct() {
    return Product(
      id: const Uuid().v4(),
      barcode: '0123456789',
      name: 'Super food 250g',
    );
  }
}
