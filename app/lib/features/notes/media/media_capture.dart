import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

/// A captured or picked file before it is copied into the media store.
typedef PickedMedia = ({String path, String extension});

/// Camera, gallery and microphone access. Swapped for a fake in tests.
abstract class MediaCapture {
  bool get canUseCamera;

  Future<PickedMedia?> takePhoto();
  Future<PickedMedia?> pickImage();
  Future<PickedMedia?> recordVideo();
  Future<PickedMedia?> pickVideo();

  /// Asks for (or checks) the microphone permission.
  Future<bool> microphonePermission();
  Future<void> startRecording(String path);

  /// Stops and returns the recorded file path.
  Future<String?> stopRecording();
  Future<void> cancelRecording();
}

class DeviceMediaCapture implements MediaCapture {
  final _picker = ImagePicker();
  AudioRecorder? _recorder;

  AudioRecorder get _rec => _recorder ??= AudioRecorder();

  PickedMedia? _picked(XFile? f, String fallbackExt) {
    if (f == null) return null;
    final dot = f.name.lastIndexOf('.');
    final ext = dot < 0 ? fallbackExt : f.name.substring(dot + 1);
    return (path: f.path, extension: ext);
  }

  @override
  bool get canUseCamera => _picker.supportsImageSource(ImageSource.camera);

  @override
  Future<PickedMedia?> takePhoto() async => _picked(
    await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      imageQuality: 85,
    ),
    'jpg',
  );

  @override
  Future<PickedMedia?> pickImage() async =>
      _picked(await _picker.pickImage(source: ImageSource.gallery), 'jpg');

  @override
  Future<PickedMedia?> recordVideo() async => _picked(
    await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 5),
    ),
    'mp4',
  );

  @override
  Future<PickedMedia?> pickVideo() async =>
      _picked(await _picker.pickVideo(source: ImageSource.gallery), 'mp4');

  @override
  Future<bool> microphonePermission() async {
    try {
      return await _rec.hasPermission();
    } catch (e) {
      debugPrint('Microphone unavailable: ${e.runtimeType}');
      return false;
    }
  }

  @override
  Future<void> startRecording(String path) => _rec.start(
    const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
    path: path,
  );

  @override
  Future<String?> stopRecording() => _rec.stop();

  @override
  Future<void> cancelRecording() => _rec.cancel();
}

final mediaCaptureProvider = Provider<MediaCapture>(
  (_) => DeviceMediaCapture(),
);
