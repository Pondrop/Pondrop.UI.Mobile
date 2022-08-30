import 'package:pondrop/api/submission_api.dart';
import 'package:uuid/uuid.dart';

class FakeStoreSubmissionTemplates {
  static List<SubmissionTemplateDto> fakeTemplates() {
    final templates = [
      SubmissionTemplateDto(
          id: const Uuid().v4(),
          title: 'Low stocked item',
          description: 'Report low or empty stock levels',
          iconCodePoint: 0xe4ee,
          iconFontFamily: 'MaterialIcons',
          steps: [
            SubmissionTemplateStepDto(
                id: const Uuid().v4(),
                title: 'Shelf ticket',
                instructions:
                    'Take a photo of the shelf ticket for the low stocked item',
                instructionsContinueButton: 'Okay',
                instructionsIconCodePoint: 0xf353,
                instructionsIconFontFamily: 'MaterialIcons',
                fields: [
                  SubmissionTemplateFieldDto(
                      id: const Uuid().v4(),
                      label: '',
                      mandatory: true,
                      fieldType: SubmissionFieldType.photo,
                      maxValue: 1),
                  SubmissionTemplateFieldDto(
                    id: const Uuid().v4(),
                    label: 'Quantity',
                    mandatory: true,
                    fieldType: SubmissionFieldType.integer,
                  ),
                  SubmissionTemplateFieldDto(
                    id: const Uuid().v4(),
                    label: 'Ticket price',
                    mandatory: true,
                    fieldType: SubmissionFieldType.currency,
                  ),
                  SubmissionTemplateFieldDto(
                      id: const Uuid().v4(),
                      label: 'Aisle',
                      mandatory: false,
                      fieldType: SubmissionFieldType.picker,
                      pickerValues: _aislePickerValues()),
                  SubmissionTemplateFieldDto(
                      id: const Uuid().v4(),
                      label: 'Shelf number',
                      mandatory: false,
                      fieldType: SubmissionFieldType.picker,
                      pickerValues: _shelvePickerValues()),
                  SubmissionTemplateFieldDto(
                      id: const Uuid().v4(),
                      label: 'Comments',
                      mandatory: false,
                      fieldType: SubmissionFieldType.multilineText,
                      maxValue: 500),
                ]),
            SubmissionTemplateStepDto(
                id: const Uuid().v4(),
                title: 'Location',
                instructions:
                    'Take a photo of the shelf for the low stocked product',
                instructionsContinueButton: 'Got it!',
                instructionsSkipButton: 'Skip',
                instructionsIconCodePoint: 0xf86e,
                instructionsIconFontFamily: 'MaterialIcons',
                fields: [
                  SubmissionTemplateFieldDto(
                      id: const Uuid().v4(),
                      label: '',
                      mandatory: true,
                      fieldType: SubmissionFieldType.photo,
                      maxValue: 1),
                ])
          ])
    ];

    return templates;
  }

  static List<String> _aislePickerValues() {
    final values = [
      'Fruit and veg',
      'Deli',
      'Freezers',
      'Checkout',
      'Stationary',
      'News/Magazines',
    ];

    for (var i = 1; i <= 30; i++) {
      values.add(i.toString());
    }

    return values;
  }

  static List<String> _shelvePickerValues() {
    final values = <String>[];

    const maxNum = 10;
    for (var i = 1; i <= maxNum; i++) {
      switch (i) {
        case 1:
          values.add('$i (Top)');
          break;
        case maxNum:
          values.add('$i (Bottom)');
          break;
        default:
          values.add(i.toString());
          break;
      }
    }

    return values;
  }
}
