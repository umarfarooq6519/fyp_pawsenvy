import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final storage = FirebaseStorage.instance;
  var uuid = Uuid();

  Future<List<String>> getAllAvatars() async {
    final ListResult result = await storage.ref('pet_avatars/').listAll();
    final urls = await Future.wait(
      result.items.map((ref) => ref.getDownloadURL()),
    );
    return urls;
  }

  Future<String?> uploadPetAvatar() async {
    try {
      final String v4 = uuid.v4();

      // trigger the gallery picker
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      // Compress the image
      final compressed = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 70,
        minWidth: 512,
        minHeight: 512,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) return null;

      // upload compressed image to firebase storage
      final filePath = 'pet_avatars/pet-$v4.jpg';
      final ref = storage.ref(filePath);
      await ref.putData(Uint8List.fromList(compressed));

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) print('Upload error: $e');
      return null;
    }
  }

  Future<String?> uploadUserAvatar(String uID) async {
    try {
      // trigger the gallery picker
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      // Compress the image
      final compressed = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 70,
        minWidth: 512,
        minHeight: 512,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) return null;

      // upload compressed image to firebase storage
      final filePath = 'user_avatars/user-$uID.jpg';
      final ref = storage.ref(filePath);
      await ref.putData(Uint8List.fromList(compressed));

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) print('Upload error: $e');
      return null;
    }
  }
}
