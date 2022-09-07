import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
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

    final response = await _httpClient.get(Uri.https(_baseUrl, '/SubmissionTemplate'),
        headers: headers);

    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body);
      final submissionTemplates = jsonList
          .map((model) => SubmissionTemplateDto.fromJson(model))
          .toList();

      _localTemplates[accessToken] = submissionTemplates;

      return submissionTemplates;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<void> submitResult(
      String? accessToken, SubmissionResultDto result) async {
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
