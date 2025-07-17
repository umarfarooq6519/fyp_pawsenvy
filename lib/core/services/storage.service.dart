import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends ChangeNotifier {
  final storage = FirebaseStorage.instance;

  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  Future<void> getAllAvatars() async {
    _isLoading = true;
    notifyListeners();

    final ListResult result = await storage.ref('pet_avatars/').listAll();
    final urls = await Future.wait(
      result.items.map((ref) => ref.getDownloadURL()),
    );

    _imageUrls = urls;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deletePetAvatar(String avatarUrl) async {
    try {
      _imageUrls.remove(avatarUrl);

      final String path = _extractPathFromUrl(avatarUrl);
      await storage.ref(path).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Delete error: $e');
      }
    }
    notifyListeners();
  }

  Future<String?> uploadPetAvatar() async {
    _isUploading = true;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      final file = File(image.path);
      final filePath =
          'pet_avatars/avatar_${DateTime.now().millisecondsSinceEpoch}.png';

      final ref = storage.ref(filePath);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      _imageUrls.add(downloadUrl);
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) print('Upload error: $e');
      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  String _extractPathFromUrl(String url) {
    final uri = Uri.parse(url);
    final encodedPath = uri.path.split('/o/').last;
    return Uri.decodeComponent(encodedPath.split('?').first);
  }
}
