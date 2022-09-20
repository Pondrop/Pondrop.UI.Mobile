import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product(
      {required this.id,
      required this.barcode,
      required this.name,});

  final String id;
  final String barcode;
  final String name;

  @override
  List<Object> get props => [
        id,
        barcode,
        name,
      ];
}
