import 'package:image_picker_platform_interface/src/types/image_source.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> verificarPermisos(ImageSource source) async {
  final cameraStatus = await Permission.camera.request();
  final storageStatus = await Permission.photos.request();

  return cameraStatus.isGranted && storageStatus.isGranted;
}
