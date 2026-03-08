import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

class SupportFaqScreen extends StatelessWidget {
  const SupportFaqScreen({super.key});

  static const List<_FaqItem> _faqItems = [
    _FaqItem(
      question: 'What can listeners do in Listenly?',
      answer:
          'Listeners can discover songs, stream music, like tracks, favorite playlists, manage their profile, and reset account credentials directly from the mobile app.',
    ),
    _FaqItem(
      question: 'What support does the app provide for artists?',
      answer:
          'Artists can upload and manage songs, review performance stats, play their own tracks from the artist area, and request artist verification from the profile section.',
    ),
    _FaqItem(
      question: 'How does artist verification work?',
      answer:
          'A user can submit a verification request with a short message. The request is reviewed by the admin side of the platform, and the latest status is shown back in the app.',
    ),
    _FaqItem(
      question: 'How do password and account updates work?',
      answer:
          'Users can update profile details, change passwords from the profile settings, and use the email reset flow if they forget their password.',
    ),
    _FaqItem(
      question: 'Does the mobile app support admin accounts?',
      answer:
          'No. Admin accounts are redirected away from the mobile experience and should use the web application for admin tools and moderation workflows.',
    ),
  ];

  Widget _buildHighlightCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.xl,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyMedium.copyWith(
                    fontWeight: AppText.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppText.small.copyWith(
                    color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Support & FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.16),
                          theme.colorScheme.secondary.withValues(alpha: 0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Everything in one place',
                          style: AppText.headline.copyWith(
                            fontSize: 26,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Listenly helps listeners stream music and helps artists manage releases, track growth, and request verification without leaving the app.',
                          style: AppText.body.copyWith(
                            color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 620;
                      final cards = [
                        _buildHighlightCard(
                          context: context,
                          icon: Icons.headphones_rounded,
                          title: 'For listeners',
                          description:
                              'Stream tracks, like songs, save playlists, and manage your account from one profile flow.',
                        ),
                        _buildHighlightCard(
                          context: context,
                          icon: Icons.graphic_eq_rounded,
                          title: 'For artists',
                          description:
                              'Upload songs, review stats, and request artist verification directly from mobile.',
                        ),
                      ];

                      if (!isWide) {
                        return Column(
                          children: [
                            cards[0],
                            const SizedBox(height: 12),
                            cards[1],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: cards[0]),
                          const SizedBox(width: 12),
                          Expanded(child: cards[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Frequently asked questions',
                    style: AppText.headline.copyWith(
                      fontSize: 22,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._faqItems.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AppRadius.xl,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Theme(
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 4,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                          iconColor: theme.colorScheme.primary,
                          collapsedIconColor: theme.colorScheme.primary,
                          title: Text(
                            item.question,
                            style: AppText.bodyMedium.copyWith(
                              fontWeight: AppText.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          children: [
                            Text(
                              item.answer,
                              style: AppText.body.copyWith(
                                color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                              ),
                            ),
                          ],
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
    );
  }
}