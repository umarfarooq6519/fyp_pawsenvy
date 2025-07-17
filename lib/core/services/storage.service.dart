import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends ChangeNotifier {
  final storage = FirebaseStorage.instance;

  // list of all urls
  List<String> _imageUrls = [];

  // states
  bool _isLoading = false;
  bool _isUploading = false;

  // getters
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // get all pet avatars
  Future<void> getAllAvatars() async {
    _isLoading = true;

    // fetch all images
    final ListResult result = await storage.ref('pet_avatars/').listAll();

    // get download urls
    final urls = await Future.wait(
      result.items.map((ref) => ref.getDownloadURL()),
    );

    // update the imageUrls
    _imageUrls = urls;

    _isLoading = false;

    // updateUI
    notifyListeners();
  }

  Future<void> deletePetAvatar(String avatarUrl) async {
    // images are stored as download urls
    // e.g. https://firebasestorage.googleapis.com/v0/b/pawsenvy/pet_avatars/avatar_name.png
    // we just need the last part of the url i.e. pet_avatars/avatar_name.png

    try {
      // remove from local list
      _imageUrls.remove(avatarUrl);

      // get path and delete from firebase
      final String path = _extractPathFromUrl(avatarUrl);

      await storage.ref(path).delete();
    } catch (e) {
      if (kDebugMode) {
        print('deleteAvatarUsingUrl() error occured $e');
      }
    }

    notifyListeners();
  }

  Future<String?> uploadPetAvatar() async {
    _isUploading = true;
    notifyListeners();

    try {
      // prompt to pick from gallery
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        _isUploading = false;
        notifyListeners();
        return null; // cancel upload method
      }

      File file = File(image.path);

      // define path in storage with better naming
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'pet_avatars/avatar_$timestamp.png';

      // upload the file to firebase storage
      await storage.ref(filePath).putFile(file);

      // get downloadUrl of the uploaded image
      String downloadUrl = await storage.ref(filePath).getDownloadURL();

      // update the local image list
      _imageUrls.add(downloadUrl);

      notifyListeners();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('uploadAvatar() error occured $e');
      }
      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  String _extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    // For Firebase Storage URLs, the path is in the format:
    // /v0/b/{bucket}/o/{path}
    // We need to extract the path after 'o/'
    String fullPath = uri.path;
    int startIndex = fullPath.indexOf('/o/') + 3;
    if (startIndex > 2) {
      String encodedPath = fullPath.substring(startIndex);
      // Remove any query parameters
      int queryIndex = encodedPath.indexOf('?');
      if (queryIndex != -1) {
        encodedPath = encodedPath.substring(0, queryIndex);
      }
      return Uri.decodeComponent(encodedPath);
    }

    // Fallback to original logic
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }
}
