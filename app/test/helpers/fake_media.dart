import 'dart:io';

import 'package:quest_log/features/notes/media/media_capture.dart';
import 'package:quest_log/features/notes/media/media_store.dart';

/// Media store in a fresh temporary directory.
MediaStore tempMediaStore() {
  final dir = Directory.systemTemp.createTempSync('quest_log_media_');
  return MediaStore(() async => dir);
}

/// Hands out prepared files instead of opening camera or microphone.
class FakeMediaCapture implements MediaCapture {
  FakeMediaCapture({this.camera = true});

  final bool camera;
  bool micGranted = true;
  int permissionRequests = 0;

  /// What the next pick/take returns.
  PickedMedia? next;
  String? _recordingPath;

  static PickedMedia sampleFile(String extension, [List<int>? bytes]) {
    final dir = Directory.systemTemp.createTempSync('quest_log_pick_');
    final f = File('${dir.path}/pick.$extension')
      ..writeAsBytesSync(bytes ?? [1, 2, 3, 4]);
    return (path: f.path, extension: extension);
  }

  @override
  bool get canUseCamera => camera;

  @override
  Future<PickedMedia?> takePhoto() async => next;

  @override
  Future<PickedMedia?> pickImage() async => next;

  @override
  Future<PickedMedia?> recordVideo() async => next;

  @override
  Future<PickedMedia?> pickVideo() async => next;

  @override
  Future<bool> microphonePermission() async {
    permissionRequests++;
    return micGranted;
  }

  @override
  Future<void> startRecording(String path) async {
    _recordingPath = path;
    File(path).writeAsBytesSync([9, 9, 9]);
  }

  @override
  Future<String?> stopRecording() async {
    final p = _recordingPath;
    _recordingPath = null;
    return p;
  }

  @override
  Future<void> cancelRecording() async => _recordingPath = null;
}
