import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// CvStepIndicator
// Progress indicator showing 5 steps of CV building:
//   1. Personal Info, 2. Work Experience, 3. Education, 4. Skills, 5. Preview & Download
//
// Shows a glowing active state, checked circles for completed steps, and connects
// them with line guides.
// ════════════════════════════════════════════════════════════════════════════════
class CvStepIndicator extends StatelessWidget {
  const CvStepIndicator({
    super.key,
    required this.currentStep,
  });

  /// 1-based index of the currently active step (1 to 5).
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final List<String> stepsEn = [
      'Personal Info',
      'Work Experience',
      'Education',
      'Skills',
      'Preview & Download'
    ];
    final List<String> stepsAr = [
      'البيانات الشخصية',
      'الخبرة العملية',
      'التعليم والشهادات',
      'المهارات',
      'معاينة وتحميل'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              final stepNum = index + 1;
              final isCompleted = stepNum < currentStep;
              final isActive = stepNum == currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    // Step bubble
                    Expanded(
                      child: Column(
                        children: [
                          _buildStepBubble(isCompleted, isActive, stepNum),
                          const SizedBox(height: 8),
                          Text(
                            '$stepNum. ${stepsEn[index]}',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: isActive || isCompleted
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isActive
                                  ? AppColors.accentBlue
                                  : isCompleted
                                      ? AppColors.textPrimary
                                      : AppColors.textDisabled,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            stepsAr[index],
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              color: isActive
                                  ? AppColors.accentBlue.withValues(alpha: 0.8)
                                  : isCompleted
                                      ? AppColors.textSecondary
                                      : AppColors.textDisabled,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Line indicator between steps (omit after the last step)
                    if (index < 4)
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [
                                isCompleted
                                    ? AppColors.accentBlue
                                    : AppColors.borderSubtle,
                                stepNum + 1 <= currentStep
                                    ? AppColors.accentBlue
                                    : AppColors.borderSubtle,
                              ],
                            ),
                            boxShadow: isCompleted
                                ? const [
                                    BoxShadow(
                                      color: AppColors.accentBlueGlow,
                                      blurRadius: 8,
                                    )
                                  ]
                                : [],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
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
