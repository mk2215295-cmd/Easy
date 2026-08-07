import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// CvStepIndicator
// Ultra-responsive, animated 5-step progress header for the CV Builder.
// On desktop (≥ 768px): Full 5-step horizontal flow with labels.
// On mobile (< 768px): Compact progress bar & step counter to prevent text overlap.
// ════════════════════════════════════════════════════════════════════════════════
class CvStepIndicator extends StatelessWidget {
  const CvStepIndicator({
    super.key,
    required this.currentStep,
    this.isArabic = false,
  });

  /// 1-based index of the currently active step (1 to 5).
  final int currentStep;
  final bool isArabic;

  static const List<String> stepsEn = [
    'Personal Info',
    'Work Experience',
    'Education',
    'Skills',
    'Preview & Download'
  ];

  static const List<String> stepsAr = [
    'البيانات الشخصية',
    'الخبرة العملية',
    'التعليم والشهادات',
    'المهارات',
    'معاينة وتحميل'
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      return _buildMobileLayout(context);
    }

    return _buildDesktopLayout(context);
  }

  // ── Mobile Responsive Layout (Compact & Clean) ──────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    final activeTitle = isArabic
        ? stepsAr[currentStep - 1]
        : stepsEn[currentStep - 1];

    final progressPct = currentStep / 5.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'الخطوة $currentStep من 5' : 'Step $currentStep of 5',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  activeTitle,
                  textAlign: isArabic ? TextAlign.left : TextAlign.right,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Animated linear progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  color: AppColors.backgroundElevated,
                ),
                FractionallySizedBox(
                  widthFactor: progressPct,
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accentBlue,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentBlueGlow,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5 Small Step Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final stepNum = index + 1;
              final isDone = stepNum <= currentStep;
              final isActive = stepNum == currentStep;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isActive ? 24 : 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isDone ? AppColors.accentBlue : AppColors.backgroundElevated,
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: AppColors.accentBlueGlow,
                            blurRadius: 8,
                          )
                        ]
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  // ── Desktop Layout (Full 5-Step Progress) ──────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: List.generate(5, (index) {
          final stepNum = index + 1;
          final isCompleted = stepNum < currentStep;
          final isActive = stepNum == currentStep;
          final title = isArabic ? stepsAr[index] : stepsEn[index];

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildStepBubble(isCompleted, isActive, stepNum),
                      const SizedBox(height: 8),
                      Text(
                        '$stepNum. $title',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: isActive || isCompleted
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.accentBlue
                              : isCompleted
                                  ? AppColors.textPrimary
                                  : AppColors.textDisabled,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < 4)
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            isCompleted ? AppColors.accentBlue : AppColors.borderSubtle,
                            stepNum + 1 <= currentStep ? AppColors.accentBlue : AppColors.borderSubtle,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepBubble(bool isCompleted, bool isActive, int stepNum) {
    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.accentBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentBlueGlow,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: AppColors.white,
          size: 18,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.backgroundPrimary : AppColors.backgroundElevated,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.accentBlue : AppColors.borderSubtle,
          width: isActive ? 2.5 : 1.5,
        ),
        boxShadow: isActive
            ? const [
                BoxShadow(
                  color: AppColors.accentBlueGlow,
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          '$stepNum',
          style: AppTextStyles.titleMedium.copyWith(
            color: isActive ? AppColors.accentBlue : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
