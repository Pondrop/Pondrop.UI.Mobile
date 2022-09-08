import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
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
      try {
        final templates =
            await _submissionApi.fetchTemplates(user!.accessToken);
        return templates;
      } catch (e) {
        log(e.toString());
      }
    }

    return const [];
  }

  Future<StoreVisitDto?> startStoreVisit(
      String storeId, LatLng? location) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      try {
        final storeVisit = await _submissionApi.startStoreVisit(
            user!.accessToken, storeId, location);
        return storeVisit;
      } catch (e) {
        log(e.toString());
      }
    }

    return null;
  }

  Future<StoreVisitDto?> endStoreVisit(
      String visitId, LatLng? location) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      try {
        final storeVisit = await _submissionApi.endStoreVisit(
            user!.accessToken, visitId, location);
        return storeVisit;
      } catch (e) {
        log(e.toString());
      }
    }

    return null;
  }

  Future<bool> submitResult(String storeVisitId, StoreSubmission submission) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = submission.toSubmissionResultDto(storeVisitId);

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
