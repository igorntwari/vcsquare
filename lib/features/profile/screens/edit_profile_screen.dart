// Edit profile form, saved to users/{uid}.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/profile_edit_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_form_field.dart';
import '../providers/profile_controller.dart';
import '../providers/profile_providers.dart';
import '../widgets/confirm_dialog.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _handle = TextEditingController();
  final TextEditingController _cohort = TextEditingController();
  final TextEditingController _roleTag = TextEditingController();
  final TextEditingController _campus = TextEditingController();
  final TextEditingController _program = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  ProfileEdit? _original;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _handle,
      _cohort,
      _roleTag,
      _campus,
      _program,
      _bio,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _fillOnce(ProfileEdit profile) {
    if (_original != null) return;
    _original = profile;
    _name.text = profile.name;
    _handle.text = profile.handle;
    _cohort.text = profile.cohort ?? '';
    _roleTag.text = profile.roleTag;
    _campus.text = profile.campus;
    _program.text = profile.program;
    _bio.text = profile.bio;
  }

  ProfileEdit _current() => ProfileEdit(
    name: _name.text,
    handle: Validators.normalizeHandle(_handle.text),
    cohort: _cohort.text,
    roleTag: _roleTag.text,
    campus: _campus.text,
    program: _program.text,
    bio: _bio.text,
    bioHighlight: _original?.bioHighlight,
  ).normalized();

  bool get _hasChanges =>
      _original != null && _current() != _original!.normalized();

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      widget.onDone?.call();
      return;
    }
    final saved = await ref
        .read(profileControllerProvider.notifier)
        .saveProfile(_current());
    if (!saved || !mounted) return;
    showAppSnackBar(context, AppStrings.profileUpdated);
    widget.onDone?.call();
  }

  Future<void> _leave() async {
    if (!_hasChanges) {
      widget.onDone?.call();
      return;
    }
    final discard = await showConfirmDialog(
      context,
      title: AppStrings.discardChangesTitle,
      message: AppStrings.discardChangesBody,
      confirmLabel: AppStrings.discard,
      cancelLabel: AppStrings.keepEditing,
      isDestructive: true,
    );
    if (discard && mounted) widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileControllerProvider, (_, next) {
      if (next.hasError) showAppSnackBar(context, AppStrings.saveFailed);
    });
    final busy = ref.watch(profileControllerProvider).isLoading;
    final loaded = ref.watch(profileProvider);
    final profile = loaded.value?.profile;
    if (profile != null) _fillOnce(ProfileEdit.fromProfile(profile));

    return PopScope(
      // Back goes through _leave to confirm unsaved edits.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !busy) _leave();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(
            tooltip: AppStrings.goBack,
            icon: const Icon(Icons.close),
            onPressed: busy ? null : _leave,
          ),
          title: Text(
            AppStrings.editProfile,
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy || profile == null ? null : _save,
              child: Text(
                AppStrings.save,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        body: profile == null
            ? (loaded.hasError
                  ? ErrorState(onRetry: () => ref.invalidate(profileProvider))
                  : const LoadingIndicator())
            : _buildForm(profile.user.avatarPath, busy),
      ),
    );
  }

  Widget _buildForm(String? avatarPath, bool busy) {
    final bioCounter = ValueListenableBuilder<TextEditingValue>(
      valueListenable: _bio,
      builder: (context, value, _) => Text(
        AppStrings.characterCount(value.text.length, AppSizes.bioMaxLength),
        textAlign: TextAlign.end,
        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
      ),
    );

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: UserAvatar(
                size: AppSizes.avatarEdit,
                imagePath: avatarPath,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.photoFromGoogle,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppFormField(
              controller: _name,
              label: AppStrings.fullNameLabel,
              hintText: AppStrings.fullNameHint,
              enabled: !busy,
              maxLength: AppSizes.nameMaxLength,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _handle,
              label: AppStrings.handleLabel,
              hintText: AppStrings.handleHint,
              enabled: !busy,
              maxLength: AppSizes.handleMaxLength + 1,
              textInputAction: TextInputAction.next,
              validator: Validators.handle,
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _cohort,
              label: AppStrings.cohortLabel,
              hintText: AppStrings.cohortHint,
              enabled: !busy,
              maxLength: AppSizes.profileLineMaxLength,
              textInputAction: TextInputAction.next,
              validator: Validators.maxLength(AppSizes.profileLineMaxLength),
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _roleTag,
              label: AppStrings.roleTagLabel,
              hintText: AppStrings.roleTagHint,
              enabled: !busy,
              maxLength: AppSizes.profileLineMaxLength,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: Validators.maxLength(AppSizes.profileLineMaxLength),
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _campus,
              label: AppStrings.campusLabel,
              hintText: AppStrings.campusHint,
              enabled: !busy,
              maxLength: AppSizes.profileLineMaxLength,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: Validators.maxLength(AppSizes.profileLineMaxLength),
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _program,
              label: AppStrings.programLabel,
              hintText: AppStrings.programHint,
              enabled: !busy,
              maxLength: AppSizes.profileLineMaxLength,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: Validators.maxLength(AppSizes.profileLineMaxLength),
            ),
            const SizedBox(height: AppSpacing.md),
            AppFormField(
              controller: _bio,
              label: AppStrings.bioLabel,
              hintText: AppStrings.bioHint,
              enabled: !busy,
              maxLength: AppSizes.bioMaxLength,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              validator: Validators.maxLength(AppSizes.bioMaxLength),
            ),
            const SizedBox(height: AppSpacing.xs),
            bioCounter,
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: AppStrings.saveChanges,
              isLoading: busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
