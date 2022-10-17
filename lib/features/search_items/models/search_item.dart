import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class SearchItem extends Equatable {
  const SearchItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.extras,
    this.iconData,
  });

  final String id;

  final String title;
  final String subtitle;

  final Map<String, String>? extras;

  final IconData? iconData;

  @override
  List<Object?> get props => [id, title, subtitle, extras];
}