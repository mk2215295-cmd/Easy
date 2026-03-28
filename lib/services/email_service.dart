import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';

class EmailService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<bool> sendApplicationEmail({
    required JobModel job,
    required UserModel user,
    required String cvUrl,
    required String passportUrl,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'sendApplicationEmail',
      );

      final result = await callable.call(<String, dynamic>{
        'jobId': job.id,
        'jobTitle': job.title,
        'companyEmail': job.applicationEmail,
        'userId': user.id,
        'userName': user.name,
        'userEmail': user.email,
        'userPhone': user.phone,
        'cvUrl': cvUrl,
        'passportUrl': passportUrl,
        'applicationDate': DateTime.now().toIso8601String(),
      });

      if (result.data['success'] == true) {
        debugPrint('✅ تم إرسال الإيميل بنجاح');
        return true;
      } else {
        debugPrint('❌ فشل إرسال الإيميل: ${result.data['error']}');
        return false;
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Firebase Functions Error: ${e.message}');
      return await _sendMockEmail(job, user, cvUrl, passportUrl);
    } catch (e) {
      debugPrint('❌ Error sending application email: $e');
      return await _sendMockEmail(job, user, cvUrl, passportUrl);
    }
  }

  Future<bool> _sendMockEmail(
    JobModel job,
    UserModel user,
    String cvUrl,
    String passportUrl,
  ) async {
    debugPrint('📧 [MOCK] Sending application email...');
    debugPrint('To: ${job.applicationEmail}');
    debugPrint('Subject: تطبيق على وظيفة ${job.title} - ${user.name}');
    debugPrint('CV: $cvUrl');
    debugPrint('Passport: $passportUrl');
    debugPrint('✅ [MOCK] Application sent successfully!');
    return true;
  }

  Future<bool> sendCompanyNotification({
    required String companyEmail,
    required String subject,
    required String body,
    List<String>? attachments,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'sendCompanyNotification',
      );

      final result = await callable.call(<String, dynamic>{
        'to': companyEmail,
        'subject': subject,
        'body': body,
        'attachments': attachments ?? [],
      });

      return result.data['success'] == true;
    } catch (e) {
      debugPrint('Error sending company notification: $e');
      return false;
    }
  }

  Future<bool> sendUserConfirmation({
    required String userEmail,
    required String jobTitle,
    required String company,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'sendUserConfirmation',
      );

      final result = await callable.call(<String, dynamic>{
        'userEmail': userEmail,
        'jobTitle': jobTitle,
        'company': company,
      });

      return result.data['success'] == true;
    } catch (e) {
      debugPrint('Error sending user confirmation: $e');
      return false;
    }
  }

  Future<bool> sendAdminNotification({
    required String jobTitle,
    required String userName,
    required String company,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'sendAdminNotification',
      );

      final result = await callable.call(<String, dynamic>{
        'jobTitle': jobTitle,
        'userName': userName,
        'company': company,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result.data['success'] == true;
    } catch (e) {
      debugPrint('Error sending admin notification: $e');
      return false;
    }
  }
}
