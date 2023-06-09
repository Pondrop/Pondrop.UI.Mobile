import 'package:equatable/equatable.dart';

class FocusItem extends Equatable {
  const FocusItem(
      {required this.id,
      required this.name,});

  final String id;
  final String name;

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
