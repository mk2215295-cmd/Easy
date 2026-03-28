import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

class PassportSecurity {
  static const String _encryptionKey = 'EASY_WORK_AI_SECRET_KEY_2024';
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<XFile?> pickPassportImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Uint8List _deriveKey(String userId) {
    final keyData = '$_encryptionKey$userId';
    final bytes = utf8.encode(keyData);
    final digest = crypto.sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  Uint8List _generateIV() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(16, (_) => random.nextInt(256)));
  }

  Uint8List _encryptData(Uint8List data, Uint8List key, Uint8List iv) {
    final cipher = GCMBlockCipher(AESEngine())
      ..init(true, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

    final encrypted = cipher.process(data);
    final result = Uint8List(iv.length + encrypted.length);
    result.setAll(0, iv);
    result.setAll(iv.length, encrypted);
    return result;
  }

  Uint8List _decryptData(Uint8List encryptedData, Uint8List key) {
    final iv = Uint8List.sublistView(encryptedData, 0, 16);
    final cipherText = Uint8List.sublistView(encryptedData, 16);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(false, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

    return cipher.process(cipherText);
  }

  Future<String?> uploadEncryptedPassport(
    XFile imageFile,
    String userId,
  ) async {
    try {
      debugPrint('🔐 بدء تشفير صورة الباسبورت...');

      final bytes = await imageFile.readAsBytes();
      final key = _deriveKey(userId);
      final iv = _generateIV();
      final encryptedBytes = _encryptData(bytes, key, iv);

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'passports/${userId}_${DateTime.now().millisecondsSinceEpoch}.enc';
      final encryptedFile = File('${tempDir.path}/${fileName.split('/').last}');
      await encryptedFile.writeAsBytes(encryptedBytes);

      final ref = _storage.ref().child(fileName);
      final uploadTask = ref.putFile(
        encryptedFile,
        SettableMetadata(
          contentType: 'application/octet-stream',
          customMetadata: {
            'encrypted': 'true',
            'algorithm': 'AES-256-GCM',
            'userId': userId,
            'originalName': imageFile.name,
          },
        ),
      );

      await uploadTask.whenComplete(() {
        debugPrint('✅ تم رفع الباسبورت المشفر بنجاح: $fileName');
      });

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('❌ Error uploading encrypted passport: $e');
      return null;
    }
  }

  Future<Uint8List?> downloadAndDecryptPassport(
    String encryptedUrl,
    String userId,
  ) async {
    try {
      final ref = _storage.refFromURL(encryptedUrl);
      final data = await ref.getData();

      if (data == null) return null;

      final key = _deriveKey(userId);
      final decryptedBytes = _decryptData(data, key);

      return decryptedBytes;
    } catch (e) {
      debugPrint('❌ Error decrypting passport: $e');
      return null;
    }
  }

  Future<bool> verifyPassport(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      bool hasMinimumSize = bytes.length > 10000;
      bool hasValidFormat =
          imageFile.path.toLowerCase().endsWith('.jpg') ||
          imageFile.path.toLowerCase().endsWith('.jpeg') ||
          imageFile.path.toLowerCase().endsWith('.png');

      return hasMinimumSize && hasValidFormat;
    } catch (e) {
      debugPrint('Error verifying passport: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> processPassport(
    XFile imageFile,
    String userId,
  ) async {
    final isValid = await verifyPassport(imageFile);

    if (!isValid) {
      return {'success': false, 'message': 'صورة الباسبورت غير صالحة'};
    }

    final encryptedUrl = await uploadEncryptedPassport(imageFile, userId);

    if (encryptedUrl != null) {
      return {
        'success': true,
        'url': encryptedUrl,
        'message': 'تم رفع الباسبورت وتشفيره بنجاح ✅',
      };
    }

    return {'success': false, 'message': 'فشل في رفع الباسبورت'};
  }

  String hashPassportData(String passportNumber, String expiryDate) {
    final data =
        '$passportNumber$expiryDate${DateTime.now().toIso8601String()}';
    final bytes = utf8.encode(data);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
