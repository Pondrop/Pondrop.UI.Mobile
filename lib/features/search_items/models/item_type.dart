import 'package:pondrop/api/submissions/models/submission_template_field_dto.dart';

enum SearchItemType { category, product }

extension SubmissionFieldItemTypeX on SubmissionFieldItemType {
  SearchItemType toSearchItemType() {
    switch (this) {
      case SubmissionFieldItemType.products:
        return SearchItemType.product;
      case SubmissionFieldItemType.categories:
        return SearchItemType.category;
      default:
        throw Exception('Not supported "$this"');
    }
  }
}

