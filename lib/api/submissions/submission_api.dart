import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/api/submissions/models/models.dart';

class SubmissionApi {
  SubmissionApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'template-submission-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';
  static const Map<String, String> _requestHeaders = {
    'Content-type': 'application/json'
  };

  final http.Client _httpClient;

  List<SubmissionTemplateDto>? _localTemplates;

  Future<List<SubmissionTemplateDto>> fetchTemplates(
      String? accessToken) async {
    if (_localTemplates?.isNotEmpty == true) {
      return _localTemplates!;
    }

    if (accessToken?.isNotEmpty == true) {
      final headers = Map<String, String>.from(_requestHeaders)
        ..addAll({'Authorization': 'Bearer ${accessToken ?? ""}'});

      final response = await _httpClient.get(Uri.https(_baseUrl, '/SubmissionTemplate'),
          headers: headers);

      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        final submissionTemplates = jsonList
            .map((model) => SubmissionTemplateDto.fromJson(model))
            .toList();

        if (submissionTemplates.isNotEmpty) {
          _localTemplates = submissionTemplates;
        }

        return submissionTemplates;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
    }

    return [];
  }
}
