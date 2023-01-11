import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_dto.g.dart';

enum ShoppingListType { unknown, grocery }

@JsonSerializable()
class ShoppingListDto {
  const ShoppingListDto({
    required this.id,
    required this.name,
    required this.type,
    required this.storeIds,
    required this.sharedListShopperIds,
    required this.listItemIds,
    required this.sortOrder,
    required this.createdUtc,
    required this.updatedUtc,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'shoppingListType')
  final ShoppingListType type;

  @JsonKey(name: 'selectedStoreIds')
  final List<String> storeIds;
  @JsonKey(name: 'sharedListShopperIds')
  final List<String> sharedListShopperIds;
  @JsonKey(name: 'listItemIds')
  final List<String> listItemIds;

  @JsonKey(name: 'sortOrder')
  final int sortOrder;

  @JsonKey(name: 'createdUtc')
  final DateTime createdUtc;
  @JsonKey(name: 'updatedUtc')
  final DateTime updatedUtc;

  static ShoppingListDto fromJson(Map<String, dynamic> json) =>
      _$ShoppingListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListDtoToJson(this);
}
