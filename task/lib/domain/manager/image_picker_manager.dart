import 'dart:io';

abstract class ImagePickerManager {
  Future<File?> getImage();
}
