import 'dart:io';

import 'package:task/domain/manager/image_picker_manager.dart';

class GetImageUseCase {
  final ImagePickerManager _imagePickerManager;

  const GetImageUseCase(this._imagePickerManager);

  Future<File?> getImage() => _imagePickerManager.getImage();
}
