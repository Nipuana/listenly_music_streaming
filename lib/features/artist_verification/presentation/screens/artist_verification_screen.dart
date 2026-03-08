import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';
import 'package:weplay_music_streaming/features/artist_verification/presentation/state/artist_verification_state.dart';
import 'package:weplay_music_streaming/features/artist_verification/presentation/view_model/artist_verification_view_model.dart';

class ArtistVerificationScreen extends ConsumerStatefulWidget {
  const ArtistVerificationScreen({super.key});

  @override
  ConsumerState<ArtistVerificationScreen> createState() =>
      _ArtistVerificationScreenState();
}

class _ArtistVerificationScreenState
    extends ConsumerState<ArtistVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(artistVerificationViewModelProvider.notifier).loadMyRequest();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF388E3C);
      case 'declined':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFF57C00);
    }
  }

  String _titleForRequest(ArtistVerificationRequestEntity request) {
    if (request.isApproved) {
      return 'You are approved as an artist';
    }
    if (request.isDeclined) {
      return 'Your last request was declined';
    }
    return 'Your verification request is pending';
  }

  String _descriptionForRequest(ArtistVerificationRequestEntity request) {
    if (request.isApproved) {
      return 'Your account has already been verified for artist access.';
    }
    if (request.isDeclined) {
      return 'You can review the admin note below and submit a new request.';
    }
    return 'Our team will review your request. You cannot submit another one while this is pending.';
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Unknown';
    }
    return DateFormat('MMM d, yyyy').format(value.toLocal());
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ref
        .read(artistVerificationViewModelProvider.notifier)
        .submitRequest(_messageController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(artistVerificationViewModelProvider);
    final request = state.currentRequest;
    final isLoading = state.status == ArtistVerificationStatusState.loading;
    final isSubmitting = state.status == ArtistVerificationStatusState.submitting;
    final hasPendingRequest = request?.isPending ?? false;
    final isApproved = request?.isApproved ?? false;

    ref.listen<ArtistVerificationState>(
      artistVerificationViewModelProvider,
      (previous, next) {
        if (!mounted) {
          return;
        }

        if (previous?.status == ArtistVerificationStatusState.submitting &&
            next.status == ArtistVerificationStatusState.success &&
            next.successMessage != null) {
          MysnackUtils.showSuccess(context, next.successMessage!);
          _messageController.clear();
        }

        if (previous?.status == ArtistVerificationStatusState.submitting &&
            next.status == ArtistVerificationStatusState.error &&
            next.errorMessage != null) {
          MysnackUtils.showError(context, next.errorMessage!);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify as Artist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request artist access',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: AppText.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceY3),
                          Text(
                            'Tell the admin team why you should be verified as an artist. Include any details that help them review your account.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceY4),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.x6),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (request != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.x6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _titleForRequest(request),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(request.status)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    request.status.toUpperCase(),
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: _statusColor(request.status),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.spaceY3),
                            Text(
                              _descriptionForRequest(request),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceY4),
                            Text(
                              'Submitted: ${_formatDate(request.createdAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if ((request.message ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.spaceY4),
                              Text(
                                'Your message',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                request.message!.trim(),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                            if ((request.adminNote ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.spaceY4),
                              Text(
                                'Admin note',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                request.adminNote!.trim(),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  if (state.status == ArtistVerificationStatusState.error &&
                      state.errorMessage != null &&
                      request == null) ...[
                    const SizedBox(height: AppSpacing.spaceY4),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.x6),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(child: Text(state.errorMessage!)),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(artistVerificationViewModelProvider.notifier)
                                    .loadMyRequest();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.spaceY4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x6),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isApproved ? 'Verification complete' : 'Verification message',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceY3),
                            TextFormField(
                              controller: _messageController,
                              enabled: !hasPendingRequest && !isApproved && !isSubmitting,
                              minLines: 6,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText:
                                    'Example: I am releasing original music on this platform and want access to artist tools.',
                                filled: true,
                                fillColor: AppColors.inputFill,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Enter a verification message';
                                }
                                if (text.length < 10) {
                                  return 'Message must be at least 10 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.spaceY4),
                            AppButton(
                              text: hasPendingRequest
                                  ? 'Request Pending'
                                  : isApproved
                                      ? 'Already Verified'
                                      : 'Submit Verification Request',
                              isLoading: isSubmitting,
                              onPressed: hasPendingRequest || isApproved || isSubmitting
                                  ? null
                                  : _submit,
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