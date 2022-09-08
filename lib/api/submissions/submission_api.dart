import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/extensions/extensions.dart';
import 'package:pondrop/api/submissions/models/models.dart';

class SubmissionApi {
  SubmissionApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'template-submission-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;
  final Map<String, List<SubmissionTemplateDto>> _localTemplates = {};

  Future<List<SubmissionTemplateDto>> fetchTemplates(String accessToken) async {
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

    _localTemplates[accessToken] = submissionTemplates;

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
    await Future.delayed(const Duration(seconds: 1));
    final json = jsonEncode(result);
    log(json);
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}