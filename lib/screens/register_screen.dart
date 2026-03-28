import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';
import '../models/user_model.dart';
import '../services/passport_security.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isPassportUploaded = false;
  String? _passportUrl;
  final PassportSecurity _passportService = PassportSecurity();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickPassport() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.accentCyan),
              title: const Text('كاميرا'),
              onTap: () async {
                Navigator.pop(context);
                await _uploadPassport(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppTheme.accentPurple,
              ),
              title: const Text('معرض الصور'),
              onTap: () async {
                Navigator.pop(context);
                await _uploadPassport(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadPassport(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _isLoading = true);

        final userId = _emailController.text.isNotEmpty
            ? _emailController.text.trim()
            : 'temp_${DateTime.now().millisecondsSinceEpoch}';

        final result = await _passportService.processPassport(image, userId);

        if (mounted) {
          setState(() => _isLoading = false);

          if (result['success'] == true) {
            setState(() {
              _isPassportUploaded = true;
              _passportUrl = result['url'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفع جواز السفر بنجاح ✅'),
                backgroundColor: AppTheme.accentGreen,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'فشل رفع جواز السفر'),
                backgroundColor: AppTheme.accentRed,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في رفع الصورة: $e'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء الموافقة على الشروط والأحكام'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          passportUrl: _passportUrl,
          createdAt: DateTime.now(),
          role: 'user',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toJson());

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ في التسجيل';
      switch (e.code) {
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جداً';
          break;
        case 'email-already-in-use':
          message = 'البريد الإلكتروني مستخدم مسبقاً';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صالح';
          break;
        case 'operation-not-allowed':
          message = 'التسجيل غير متاح حالياً';
          break;
        case 'too-many-requests':
          message = 'تم تجاوز عدد المحاولات، حاول لاحقاً';
          break;
        case 'network-request-failed':
          message = 'تحقق من اتصال الإنترنت';
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.accentRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء حساب جديد'),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoCard(),
                          const SizedBox(height: 25),
                          _buildNameField(),
                          const SizedBox(height: 15),
                          _buildEmailField(),
                          const SizedBox(height: 15),
                          _buildPhoneField(),
                          const SizedBox(height: 15),
                          _buildPasswordField(),
                          const SizedBox(height: 15),
                          _buildConfirmPasswordField(),
                          const SizedBox(height: 25),
                          _buildPassportUpload(),
                          const SizedBox(height: 25),
                          _buildTermsCheckbox(),
                          const SizedBox(height: 30),
                          _buildRegisterButton(),
                          const SizedBox(height: 20),
                          _buildLoginLink(),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.accentPurple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: AppTheme.accentCyan, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تحقق من الهوية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                ),
                Text(
                  'رفع جواز السفر يزيد فرص توظيفك',
                  style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          if (_isPassportUploaded)
            const Icon(
              Icons.check_circle,
              color: AppTheme.accentGreen,
              size: 25,
            ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال الاسم';
        }
        if (value.length < 3) {
          return 'الاسم يجب أن يكون 3 أحرف على الأقل';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'الاسم الكامل',
        prefixIcon: Icon(Icons.person_outline, color: AppTheme.accentPurple),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!value.contains('@')) {
          return 'الرجاء إدخال بريد إلكتروني صالح';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(Icons.email_outlined, color: AppTheme.accentPurple),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال رقم الهاتف';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'رقم الهاتف',
        prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.accentPurple),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.accentPurple,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.textGrey,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: const TextStyle(color: AppTheme.textWhite),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء تأكيد كلمة المرور';
        }
        if (value != _passwordController.text) {
          return 'كلمة المرور غير متطابقة';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'تأكيد كلمة المرور',
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.accentPurple,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.textGrey,
          ),
          onPressed: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
        ),
      ),
    );
  }

  Widget _buildPassportUpload() {
    return GestureDetector(
      onTap: _pickPassport,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _isPassportUploaded
                ? AppTheme.accentGreen
                : AppTheme.accentPurple.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isPassportUploaded
                    ? AppTheme.accentGreen.withOpacity(0.15)
                    : AppTheme.accentPurple.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPassportUploaded ? Icons.check : Icons.badge,
                color: _isPassportUploaded
                    ? AppTheme.accentGreen
                    : AppTheme.accentPurple,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isPassportUploaded
                        ? 'تم رفع جواز السفر ✅'
                        : 'رفع جواز السفر (اختياري)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isPassportUploaded
                          ? AppTheme.accentGreen
                          : AppTheme.textWhite,
                    ),
                  ),
                  Text(
                    'صورة جواز السفر للتعريف',
                    style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.upload_file, color: AppTheme.accentCyan),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() => _acceptTerms = value ?? false);
            },
            activeColor: AppTheme.accentCyan,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _acceptTerms = !_acceptTerms);
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: AppTheme.textGrey, fontSize: 13),
                  children: [
                    const TextSpan(text: 'أوافق على '),
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' و'),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'إنشاء حساب',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('لديك حساب بالفعل؟', style: TextStyle(color: AppTheme.textGrey)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'تسجيل دخول',
              style: TextStyle(
                color: AppTheme.accentCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
