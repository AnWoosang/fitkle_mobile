import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class NewsContentMarkdown extends StatelessWidget {
  final String content;

  const NewsContentMarkdown({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: 15,
          height: 1.7,
          color: AppTheme.foreground,
        ),
        h1: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppTheme.foreground,
          height: 1.3,
        ),
        h2: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: AppTheme.foreground,
          height: 1.3,
        ),
        h3: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppTheme.foreground,
          height: 1.3,
        ),
        blockquote: const TextStyle(
          color: AppTheme.foreground,
          fontSize: 15,
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
        blockquoteDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppTheme.primary.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: const Border(
            left: BorderSide(
              color: AppTheme.primary,
              width: 4,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        code: const TextStyle(
          backgroundColor: AppTheme.muted,
          color: AppTheme.foreground,
          fontFamily: 'monospace',
          fontSize: 13,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppTheme.muted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
        codeblockPadding: const EdgeInsets.all(12),
        listBullet: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
        ),
        a: const TextStyle(
          color: AppTheme.primary,
          decoration: TextDecoration.underline,
          decorationThickness: 2,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          // TODO: Open link in browser
          debugPrint('Link tapped: $href');
        }
      },
    );
  }
}
