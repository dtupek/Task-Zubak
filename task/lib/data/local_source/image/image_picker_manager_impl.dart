import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:task/domain/manager/image_picker_manager.dart';

class ImagePickerManagerImpl implements ImagePickerManager {
  @override
  Future<File?> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    return File(image.path);
  }
}
