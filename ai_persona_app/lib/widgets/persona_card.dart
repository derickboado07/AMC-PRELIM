import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class PersonaCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;
  final int index;

  const PersonaCard({
    super.key,
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.onTap,
    required this.index,
  });

  @override
  State<PersonaCard> createState() => _PersonaCardState();
}

class _PersonaCardState extends State<PersonaCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: _isHovered
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppTheme.cardBorderRadius),
              gradient: LinearGradient(
                colors: [
                  palette.primaryColor.withOpacity(0.08),
                  palette.accentColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: palette.dividerColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.primaryColor.withOpacity(
                    _isHovered ? 0.15 : 0.08,
                  ),
                  blurRadius: _isHovered ? 24 : 12,
                  offset: Offset(0, _isHovered ? 12 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppTheme.cardBorderRadius),
              child: Stack(
                children: [
                  // 🎨 Background gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          palette.primaryColor.withOpacity(0.03),
                          palette.accentColor.withOpacity(0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 📌 Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🎯 Icon with Hero Animation
                      Hero(
                        tag: 'persona_icon_${widget.index}',
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                palette.primaryColor.withOpacity(0.18),
                                palette.accentColor.withOpacity(0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: palette.primaryColor.withOpacity(0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              widget.icon,
                              size: 40,
                              color: palette.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.paddingLG),
                      // 📝 Title
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingMD,
                          ),
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.paddingSM),
                      // 📌 Subtitle
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingMD,
                          ),
                          child: Text(
                            widget.subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: palette.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
            .animate(delay: Duration(milliseconds: 50 * widget.index))
            .scaleXY(begin: 0.8, end: 1.0, duration: 600.ms)
            .fadeIn(duration: 400.ms),
      ),
    );
  }
}
