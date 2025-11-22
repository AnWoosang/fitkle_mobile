import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.border,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Copyright and Social
            Column(
              children: [
                // Copyright
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '© $currentYear fitkle',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Row(
                      children: [
                        Text(
                          'Made with ',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                        Icon(
                          Icons.favorite,
                          size: 12,
                          color: AppTheme.accentRose,
                        ),
                        Text(
                          ' in Seoul',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      Icons.language,
                      'Instagram',
                      'https://instagram.com',
                      AppTheme.accentRose,
                    ),
                    const SizedBox(width: 8),
                    _buildSocialIcon(
                      Icons.chat_bubble_outline,
                      'Twitter',
                      'https://twitter.com',
                      AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _buildSocialIcon(
                      Icons.email_outlined,
                      'Email',
                      'mailto:contact@fitkle.com',
                      AppTheme.accentSage,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expandable Section
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded ? '간단히 보기' : '더보기',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppTheme.mutedForeground,
                  ),
                ],
              ),
            ),

            // Expanded Content
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.border,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Quick Links
                    Row(
                      children: [
                        // Links Column
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '링크',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildFooterLink('소개', () {}),
                              const SizedBox(height: 6),
                              _buildFooterLink('도움말', () {}),
                              const SizedBox(height: 6),
                              _buildFooterLink('문의하기', () {}),
                            ],
                          ),
                        ),

                        // Legal Column
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '법적 고지',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildFooterLink('이용약관', () {}),
                              const SizedBox(height: 6),
                              _buildFooterLink('개인정보', () {}),
                              const SizedBox(height: 6),
                              _buildFooterLink('쿠키 정책', () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Info
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.border,
                            width: 0.3,
                          ),
                        ),
                      ),
                      child: const Text(
                        'fitkle은 한국에 거주하는 외국인들이 안전하고 즐겁게 교류할 수 있는 플랫폼입니다 🌏',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.mutedForeground,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label, String url, Color hoverColor) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.border.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppTheme.mutedForeground,
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.mutedForeground,
        ),
      ),
    );
  }
}
