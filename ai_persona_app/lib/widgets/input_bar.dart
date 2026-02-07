// lib/widgets/input_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const InputBar({super.key, required this.onSendMessage});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isFocused = false;
  bool _hasText = false;

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      setState(() => _hasText = false);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Focus(
          onFocusChange: (focused) {
            setState(() => _isFocused = focused);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: palette.primaryColor.withOpacity(
                    _isFocused ? 0.2 : 0.1,
                  ),
                  blurRadius: _isFocused ? 24 : 12,
                  offset: Offset(0, _isFocused ? 12 : 8),
                ),
              ],
            ),
            child: Material(
              borderRadius:
                  BorderRadius.circular(AppTheme.inputBorderRadius),
              elevation: 0,
              color: palette.surfaceColor,
              child: Container(
                decoration: BoxDecoration(
                  color: palette.surfaceColor,
                  borderRadius:
                      BorderRadius.circular(AppTheme.inputBorderRadius),
                  border: Border.all(
                    color: _isFocused
                        ? palette.primaryColor
                        : palette.dividerColor,
                    width: _isFocused ? 2 : 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // 📝 Text Input Field
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: palette.textSecondary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingLG,
                            vertical: AppTheme.paddingMD,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: palette.textPrimary,
                        ),
                        cursorColor: palette.primaryColor,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() => _hasText = value.trim().isNotEmpty);
                        },
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    // 📤 Send Button
                    Padding(
                      padding: const EdgeInsets.only(
                        right: AppTheme.paddingMD,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _sendMessage,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppTheme.paddingSM,
                            ),
                            decoration: BoxDecoration(
                              color: _hasText
                                  ? palette.primaryColor
                                  : palette.dividerColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.send,
                              size: 20,
                              color: _hasText
                                  ? Colors.white
                                  : palette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
