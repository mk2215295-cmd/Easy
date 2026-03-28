import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF2D2E4A);
  static const Color accentCyan = Color(0xFF00D2FF);
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF94A3B8);
  static const Color textDarkGrey = Color(0xFF64748B);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: primaryDark,
      primaryColor: accentCyan,
      colorScheme: ColorScheme.dark(
        primary: accentCyan,
        secondary: accentPurple,
        surface: secondaryDark,
        error: accentRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),
      textTheme: GoogleFonts.tajawalTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: textWhite, displayColor: textWhite),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPurple,
          foregroundColor: textWhite,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentCyan, width: 2),
        ),
        labelStyle: GoogleFonts.tajawal(color: textGrey),
        hintStyle: GoogleFonts.tajawal(color: textDarkGrey),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryDark,
        selectedColor: accentPurple,
        labelStyle: GoogleFonts.tajawal(color: textWhite),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static List<Color> get gradientPrimary => [accentPurple, accentCyan];
  static List<Color> get gradientDark => [primaryDark, secondaryDark];
  static List<Color> get gradientHero => [Color(0xFF6C63FF), Color(0xFF00D2FF)];
}

class AppStrings {
  static const String appName = 'EASY WORK AI';
  static const String appTagline = 'مستقبلك يبدأ هنا';
  static const String futureOfRecruitment = ' FUTURE OF RECRUITMENT';

  static const String login = 'دخول';
  static const String register = 'تسجيل';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String name = 'الاسم';
  static const String phone = 'رقم الهاتف';
  static const String createAccount = 'إنشاء حساب جديد';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟';
  static const String dontHaveAccount = 'ليس لديك حساب؟';

  static const String dashboard = 'لوحة التحكم';
  static const String jobs = 'الوظائف';
  static const String profile = 'الملف الشخصي';
  static const String settings = 'الإعدادات';
  static const String notifications = 'الإشعارات';
  static const String smart = 'الذكي';

  static const String smartRadar = 'رادار الوظائف';
  static const String europe = 'أوروبا';
  static const String turkey = 'تركيا';
  static const String canada = 'كندا';
  static const String germany = 'ألمانيا';

  static const String applyNow = 'تقديم الآن';
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';

  static const String loading = 'جاري التحميل...';
  static const String error = 'حدث خطأ';
  static const String success = 'تم بنجاح';
  static const String noData = 'لا توجد بيانات';
}

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String jobsList = '/jobs';
  static const String jobDetails = '/job-details';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String smartProfile = '/smart-profile';
  static const String chatAssistant = '/chat-assistant';
}
