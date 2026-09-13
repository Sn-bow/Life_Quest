import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'device_backup.dart';

abstract class BackupFiles {
  Future<Uint8List?> open();
  Future<bool> save(Uint8List bytes, String filename);
}

class NativeBackupFiles implements BackupFiles {
  @override
  Future<Uint8List?> open() async {
    // Android providers do not consistently understand custom MIME types.
    // Validate size/format/authentication after the user's explicit selection.
    final file = await FilePicker.pickFile();
    if (file == null) return null;
    if ((file.lengthSync() ?? 0) > DeviceBackupCodec.maxFileBytes) {
      throw const InvalidBackup();
    }
    final buffer = BytesBuilder(copy: false);
    await for (final chunk in file.readAsByteStream()) {
      if (buffer.length + chunk.length > DeviceBackupCodec.maxFileBytes) {
        throw const InvalidBackup();
      }
      buffer.add(chunk);
    }
    return buffer.takeBytes();
  }

  @override
  Future<bool> save(Uint8List bytes, String filename) async =>
      await FilePicker.saveFile(fileName: filename, bytes: bytes) != null;
}
