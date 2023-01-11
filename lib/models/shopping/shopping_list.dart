import 'package:equatable/equatable.dart';

part 'shopping_list_item.dart';

class ShoppingList extends Equatable {
  const ShoppingList({
    required this.id,
    required this.name,
    this.iconCodePoint = 0xf37f,
    this.iconFontFamily = 'MaterialIcons',
    this.items = const [],
    this.itemCount = 0,
    this.sortOrder = 0,
  });

  final String id;
  final String name;

  final int iconCodePoint;
  final String iconFontFamily;

  final List<ShoppingListItem> items;
  final int itemCount;

  final int sortOrder;

  ShoppingList copyWith({
    String? name,
    List<ShoppingListItem>? items,
    int? itemCount,
    int? sortOrder,
  }) {
    return ShoppingList(
      id: id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint,
      iconFontFamily: iconFontFamily,
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object> get props =>
      [id, name, iconCodePoint, iconFontFamily, items, sortOrder];
}
