import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';

class PhotoFieldControl extends StatelessWidget {
  const PhotoFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 256,
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.75),
        child: field.result.photoPathValue?.isNotEmpty == true
            ? Image.file(File(field.result.photoPathValue!))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await takePhoto(
                            context.read<StoreSubmissionBloc>(), field);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.white),
                      child: Text(l10n.takePhoto),
                    )
                  ]),
      ),
    );
  }

  static Future<void> takePhoto(
      StoreSubmissionBloc bloc, StoreSubmissionField field) async {
    if (field.fieldType == SubmissionFieldType.photo) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        bloc.add(StoreSubmissionFieldResultEvent(
            stepId: field.stepId,
            fieldId: field.fieldId,
            result: StoreSubmissionFieldResult(photoPathValue: image.path)));
      }
    }
  }
}
