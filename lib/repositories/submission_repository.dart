import 'package:geolocator/geolocator.dart';
import 'package:pondrop/api/submission_api.dart';


class SubmissionRepository {
  SubmissionRepository({SubmissionApi? submissionApi})
      : _submissionApi = submissionApi ?? SubmissionApi();

  final SubmissionApi _submissionApi;

 Future<List<SubmissionTemplateDto>> fetchTemplates(String accessToken) async {
    final templates = await _submissionApi.fetchTemplates(accessToken);
    return templates;
  }
}