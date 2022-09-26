import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/extensions/extensions.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:uuid/uuid.dart';

class SubmissionApi {
  SubmissionApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'template-submission-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;
  final Map<String, List<SubmissionTemplateDto>> _localTemplates = {};

  Future<List<SubmissionTemplateDto>> fetchTemplates(String accessToken) async {
    return fakeTemplates();

    if (_localTemplates.isNotEmpty) {
      if (_localTemplates.containsKey(accessToken)) {
        return _localTemplates[accessToken]!;
      }
      _localTemplates.clear();
    }

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient
        .get(Uri.https(_baseUrl, '/SubmissionTemplate'), headers: headers);

    response.ensureSuccessStatusCode();

    Iterable jsonList = json.decode(response.body);
    final submissionTemplates =
        jsonList.map((model) => SubmissionTemplateDto.fromJson(model)).toList();

    if (submissionTemplates.isNotEmpty) {
      _localTemplates[accessToken] = submissionTemplates;
    }

    return submissionTemplates;
  }

  Future<StoreVisitDto> startStoreVisit(
      String accessToken, String storeId, LatLng? location) async {
    final json = jsonEncode({
      'storeId': storeId,
      'latitude': location?.latitude ?? 0,
      'longitude': location?.longitude ?? 0,
    });

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/StoreVisit/create'),
        headers: headers,
        body: json);

    response.ensureSuccessStatusCode();

    final storeVisit = StoreVisitDto.fromJson(jsonDecode(response.body));
    return storeVisit;
  }

  Future<StoreVisitDto> endStoreVisit(
      String accessToken, String visitId, LatLng? location) async {
    final json = jsonEncode({
      'id': visitId,
      'shopModeStatus': 'Completed',
      'latitude': location?.latitude ?? 0,
      'longitude': location?.longitude ?? 0,
    });

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.put(
        Uri.https(_baseUrl, '/StoreVisit/update'),
        headers: headers,
        body: json);

    response.ensureSuccessStatusCode();

    final storeVisit = StoreVisitDto.fromJson(jsonDecode(response.body));
    return storeVisit;
  }

  Future<void> submitResult(
      String accessToken, SubmissionResultDto result) async {
    final json = jsonEncode(result);

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/Submission/create'),
        headers: headers,
        body: json);

    response.ensureSuccessStatusCode();
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

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
              instructionsSkipButton: 'Skip',
              instructionsIconCodePoint: 0xf353,
              instructionsIconFontFamily: 'MaterialIcons',
              fields: [
                SubmissionTemplateFieldDto(
                    id: const Uuid().v4(),
                    label: '',
                    mandatory: false,
                    fieldType: SubmissionFieldType.photo,
                    maxValue: 1),
                SubmissionTemplateFieldDto(
                    id: const Uuid().v4(),
                    label: 'Product',
                    mandatory: false,
                    fieldType: SubmissionFieldType.search,
                    itemType: SubmissionFieldItemType.products),
                SubmissionTemplateFieldDto(
                  id: const Uuid().v4(),
                  label: 'Name',
                  mandatory: false,
                  fieldType: SubmissionFieldType.text,
                ),
                SubmissionTemplateFieldDto(
                  id: const Uuid().v4(),
                  label: 'Quantity',
                  mandatory: false,
                  fieldType: SubmissionFieldType.integer,
                ),
                SubmissionTemplateFieldDto(
                  id: const Uuid().v4(),
                  label: 'Ticket price',
                  mandatory: false,
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
              ]),
          SubmissionTemplateStepDto(
              id: const Uuid().v4(),
              title: 'Summary',
              isSummary: true,
              fields: [
                SubmissionTemplateFieldDto(
                    id: const Uuid().v4(),
                    label: 'Comments',
                    mandatory: false,
                    fieldType: SubmissionFieldType.multilineText,
                    maxValue: 500),
              ])
        ],
      )
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
