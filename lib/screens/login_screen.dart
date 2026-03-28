import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (userCredential.user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ في تسجيل الدخول';
      switch (e.code) {
        case 'user-not-found':
          message = 'لا يوجد مستخدم بهذا البريد';
          break;
        case 'wrong-password':
          message = 'كلمة المرور خاطئة';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صالح';
          break;
        case 'invalid-credential':
          message = 'بيانات الدخول غير صحيحة';
          break;
        case 'too-many-requests':
          message = 'تم تجاوز عدد المحاولات، حاول لاحقاً';
          break;
        case 'network-request-failed':
          message = 'تحقق من اتصال الإنترنت';
          break;
        case 'user-disabled':
          message = 'هذا الحساب معطل';
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(),
                    const SizedBox(height: 40),
                    _buildTitle(),
                    const SizedBox(height: 50),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    _buildLoginButton(),
                    const SizedBox(height: 20),
                    _buildForgotPassword(),
                    const SizedBox(height: 40),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildCreateAccountButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentCyan, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentCyan.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.bolt_rounded,
        size: 60,
        color: AppTheme.accentCyan,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          AppStrings.futureOfRecruitment,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.textGrey,
            letterSpacing: 2,
          ),
        ),
      ],
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
      decoration: InputDecoration(
        labelText: AppStrings.email,
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: AppTheme.accentPurple,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: AppTheme.textGrey, size: 20),
          onPressed: () => _emailController.clear(),
        ),
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
        labelText: AppStrings.password,
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

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppTheme.textWhite,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                AppStrings.login,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: _showForgotPasswordDialog,
      child: Text(
        'هل نسيت كلمة المرور؟',
        style: TextStyle(color: AppTheme.textGrey),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.cardDark,
              title: const Text(
                'إعادة تعيين كلمة المرور',
                style: TextStyle(color: AppTheme.textWhite),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور.',
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('أدخل البريد الإلكتروني'),
                                backgroundColor: AppTheme.accentRed,
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text.trim(),
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                                  ),
                                  backgroundColor: AppTheme.accentGreen,
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String message;
                            switch (e.code) {
                              case 'user-not-found':
                                message = 'لا يوجد حساب بهذا البريد الإلكتروني';
                                break;
                              case 'invalid-email':
                                message = 'البريد الإلكتروني غير صالح';
                                break;
                              default:
                                message = 'حدث خطأ: ${e.message}';
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: AppTheme.accentRed,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('حدث خطأ: $e'),
                                  backgroundColor: AppTheme.accentRed,
                                ),
                              );
                            }
                          } finally {
                            setDialogState(() => isLoading = false);
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('إرسال'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppTheme.textDarkGrey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('أو', style: TextStyle(color: AppTheme.textGrey)),
        ),
        Expanded(child: Container(height: 1, color: AppTheme.textDarkGrey)),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.accentCyan, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          AppStrings.createAccount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentCyan,
          ),
        ),
      ),
    );
  }
}
