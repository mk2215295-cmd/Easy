import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ════════════════════════════════════════════════════════════════════════════
// PageTransitionWrapper — Wraps any screen with premium fade+slide entry.
// ════════════════════════════════════════════════════════════════════════════
class PageTransitionWrapper extends StatelessWidget {
  const PageTransitionWrapper({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: 450.ms, curve: Curves.easeOut);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// StaggeredListItem — Cascade entrance animation based on index.
// ════════════════════════════════════════════════════════════════════════════
class StaggeredListItem extends StatelessWidget {
  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = 60,
    this.maxDelay = 600,
  });
  final int index;
  final Widget child;
  final int baseDelay;
  final int maxDelay;

  @override
  Widget build(BuildContext context) {
    final delayMs = (index * baseDelay).clamp(0, maxDelay);
    return child
        .animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 380.ms, curve: Curves.easeOut);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// AnimatedSectionHeader — Animated section title with left accent line.
// ════════════════════════════════════════════════════════════════════════════
class AnimatedSectionHeader extends StatelessWidget {
  const AnimatedSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.delay = Duration.zero,
    this.accentColor,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Duration delay;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFF007FFF);
    return Row(
      children: [
        Container(
          width: 3,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accent, accent.withValues(alpha: 0.3)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ).animate(delay: delay).fadeIn(duration: 500.ms)
            .scaleY(begin: 0, end: 1, duration: 400.ms, curve: Curves.easeOutBack, alignment: Alignment.topCenter),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: Color(0xFFF0F6FC), letterSpacing: -0.3,
                ),
              ).animate(delay: delay + 80.ms).fadeIn(duration: 400.ms)
                  .slideX(begin: -0.05, end: 0, duration: 350.ms),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)))
                    .animate(delay: delay + 150.ms).fadeIn(duration: 400.ms),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// GlowContainer — Container with animated glow border on hover.
// ════════════════════════════════════════════════════════════════════════════
class GlowContainer extends StatefulWidget {
  const GlowContainer({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF007FFF),
    this.borderRadius = 16.0,
    this.onTap,
    this.padding,
  });
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  State<GlowContainer> createState() => _GlowContainerState();
}

class _GlowContainerState extends State<GlowContainer> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _hovered ? widget.glowColor.withValues(alpha: 0.7) : const Color(0xFF21262D),
              width: _hovered ? 1.5 : 1.0,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(color: widget.glowColor.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 4)),
                    BoxShadow(color: widget.glowColor.withValues(alpha: 0.08), blurRadius: 40, spreadRadius: 4),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
