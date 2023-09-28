import 'package:image_picker/image_picker.dart' as ip;

/// image_picker で選択する画像のソース。
enum ImageSource {
  /// 端末のギャラリーから画像を選択する。
  gallery,

  /// 端末のカメラを起動し撮影することで画像を選択する。
  camera,
}

/// 端末から画像を選択する際の各機能を提供するサービスクラス。
class ImagePickerService {
  final ip.ImagePicker _imagePicker = ip.ImagePicker();

  /// 端末の画像を選択またはカメラを起動・撮影することで、選択された画像の path
  /// 文字列を返す。
  Future<String?> pickImage(ImageSource imageSource) async {
    final xFile = await _pickImage(source: imageSource);
    if (xFile == null) {
      return null;
    }
    return xFile.path;
  }

  /// 画像を複数選択し、選択された画像の path 文字列のリストを返す。
  Future<List<String>> pickImages() async {
    final xFiles = await _imagePicker.pickMultiImage();
    return xFiles.map((xFile) => xFile.path).toList();
  }

  Future<ip.XFile?> _pickImage({required ImageSource source}) async {
    switch (source) {
      case ImageSource.gallery:
        return _imagePicker.pickImage(source: ip.ImageSource.gallery);
      case ImageSource.camera:
        return _imagePicker.pickImage(source: ip.ImageSource.camera);
    }
  }
}
