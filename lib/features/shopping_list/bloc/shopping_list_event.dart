part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object> get props => [];
}

class ItemRefreshed extends ShoppingListEvent {
  const ItemRefreshed();
}

class ItemAdded extends ShoppingListEvent {
  const ItemAdded(
      {required this.categoryId, required this.name, required this.sortOrder});

  final String categoryId;
  final String name;
  final int sortOrder;
}

class ItemDeleted extends ShoppingListEvent {
  const ItemDeleted({required this.id});

  final String id;
}

class ItemChecked extends ShoppingListEvent {
  const ItemChecked({required this.id, required this.checked});

  final String id;
  final bool checked;
}

class ItemReordered extends ShoppingListEvent {
  const ItemReordered({required this.id, required this.sortOrder});

  final String id;
  final int sortOrder;
}

class ItemCategorySearchTextChanged extends ShoppingListEvent {
  const ItemCategorySearchTextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}
