import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

class SubmissionRepository {
  SubmissionRepository(
      {required UserRepository userRepository, SubmissionApi? submissionApi})
      : _userRepository = userRepository,
        _submissionApi = submissionApi ?? SubmissionApi();

  final UserRepository _userRepository;
  final SubmissionApi _submissionApi;
  final _controller = StreamController<StoreSubmission>.broadcast();

  Stream<StoreSubmission> get submissions async* {
    yield* _controller.stream;
  }

  Future<List<SubmissionTemplateDto>> fetchTemplates() async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final templates = await _submissionApi.fetchTemplates(user!.accessToken);
      return templates;
    }

    return const [];
  }

  Future<bool> submitResult(StoreSubmission submission) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = submission.toSubmissionResultDto();

      for (final i
          in result.steps.expand((e) => e.fields.expand((e) => e.values))) {
        final path = i.photoPathValue ?? '';
        if (path.isNotEmpty) {
          final file = File(path);
          if (await file.exists()) {
            i.photoFileName = p.basename(path);
            i.photoDataBase64 = _toBase64(await _readFileBytes(file));
          }
        }
      }

      try {
        await _submissionApi.submitResult(user!.accessToken, result);
        _controller.add(submission);
        return true;
      } catch (e) {
        log(e.toString());
      }
    }

    return false;
  }

  void dispose() => _controller.close();

  Future<Uint8List> _readFileBytes(File file) async {
    final bytes = await file.readAsBytes();
    return bytes;
  }

  String _toBase64(Uint8List bytes) {
    final result = base64.encode(bytes);
    return result;
  }
}
