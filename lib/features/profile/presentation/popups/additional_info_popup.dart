import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';

class AdditionalInfoPopup extends ConsumerStatefulWidget {
  const AdditionalInfoPopup({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AdditionalInfoPopup(),
    );
  }

  @override
  ConsumerState<AdditionalInfoPopup> createState() => _AdditionalInfoPopupState();
}

class _AdditionalInfoPopupState extends ConsumerState<AdditionalInfoPopup> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _selectedGender;

  static const List<DropdownMenuItem<String>> _genderOptions = [
    DropdownMenuItem(value: 'male', child: Text('Male')),
    DropdownMenuItem(value: 'female', child: Text('Female')),
    DropdownMenuItem(value: 'other', child: Text('Other')),
    DropdownMenuItem(value: 'prefer-not-to-say', child: Text('Prefer not to say')),
  ];

  @override
  void initState() {
    super.initState();
    _loadAdditionalInfo();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _dateOfBirthController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadAdditionalInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ref.read(apiClientProvider).get(ApiEndpoints.getUserInfo);
      final data = response.data['data'];

      if (data is Map<String, dynamic>) {
        _phoneController.text = (data['phoneNumber'] as String?) ?? '';
        _addressController.text = (data['address'] as String?) ?? '';
        _cityController.text = (data['city'] as String?) ?? '';
        _countryController.text = (data['country'] as String?) ?? '';
        _postalCodeController.text = (data['postalCode'] as String?) ?? '';
        _bioController.text = (data['bio'] as String?) ?? '';

        final rawGender = data['gender'] as String?;
        if (rawGender != null && rawGender.isNotEmpty) {
          _selectedGender = rawGender;
        }

        final rawDateOfBirth = data['dateOfBirth']?.toString();
        if (rawDateOfBirth != null && rawDateOfBirth.isNotEmpty) {
          _dateOfBirthController.text = rawDateOfBirth.split('T').first;
        }
      }
    } on DioException catch (e) {
      if (!mounted) return;
      MysnackUtils.showError(
        context,
        e.response?.data['message']?.toString() ?? 'Failed to load additional info',
      );
    } catch (_) {
      if (!mounted) return;
      MysnackUtils.showError(context, 'Failed to load additional info');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _parseDate(_dateOfBirthController.text) ?? DateTime(now.year - 18);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      _dateOfBirthController.text = picked.toIso8601String().split('T').first;
    }
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAdditionalInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final payload = <String, dynamic>{
      'phoneNumber': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'postalCode': _postalCodeController.text.trim(),
      'bio': _bioController.text.trim(),
    };

    if (_selectedGender != null && _selectedGender!.isNotEmpty) {
      payload['gender'] = _selectedGender;
    }

    if (_dateOfBirthController.text.trim().isNotEmpty) {
      payload['dateOfBirth'] = _dateOfBirthController.text.trim();
    }

    try {
      await ref.read(apiClientProvider).put(ApiEndpoints.addUserInfo, data: payload);
      if (!mounted) return;
      MysnackUtils.showSuccess(context, 'Additional info updated successfully');
      Navigator.of(context).pop();
    } on DioException catch (e) {
      if (!mounted) return;
      MysnackUtils.showError(
        context,
        e.response?.data['message']?.toString() ?? 'Failed to update additional info',
      );
    } catch (_) {
      if (!mounted) return;
      MysnackUtils.showError(context, 'Failed to update additional info');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SafeArea(
              top: false,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      controller: scrollController,
                      padding: AppSpacing.px4.add(const EdgeInsets.only(top: 12, bottom: 24)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                width: 44,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                            AppSpacing.gap4,
                            Text(
                              'Additional Info',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            AppSpacing.gap2,
                            Text(
                              'Update your extended profile details.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            AppSpacing.gap4,
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(label: 'Phone Number', icon: Icons.phone_outlined),
                            ),
                            AppSpacing.gap4,
                            TextFormField(
                              controller: _addressController,
                              decoration: _inputDecoration(label: 'Address', icon: Icons.home_outlined),
                            ),
                            AppSpacing.gap4,
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: _inputDecoration(label: 'City', icon: Icons.location_city_outlined),
                                  ),
                                ),
                                AppSpacing.hGap3,
                                Expanded(
                                  child: TextFormField(
                                    controller: _countryController,
                                    decoration: _inputDecoration(label: 'Country', icon: Icons.public_outlined),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gap4,
                            TextFormField(
                              controller: _postalCodeController,
                              decoration: _inputDecoration(label: 'Postal Code', icon: Icons.markunread_mailbox_outlined),
                            ),
                            AppSpacing.gap4,
                            DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              decoration: _inputDecoration(label: 'Gender', icon: Icons.person_outline),
                              items: _genderOptions,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            AppSpacing.gap4,
                            TextFormField(
                              controller: _dateOfBirthController,
                              readOnly: true,
                              onTap: _pickDateOfBirth,
                              decoration: _inputDecoration(
                                label: 'Date of Birth',
                                icon: Icons.calendar_today_outlined,
                                suffixIcon: IconButton(
                                  onPressed: _pickDateOfBirth,
                                  icon: const Icon(Icons.edit_calendar_outlined),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }
                                return _parseDate(value) == null ? 'Enter a valid date' : null;
                              },
                            ),
                            AppSpacing.gap4,
                            TextFormField(
                              controller: _bioController,
                              minLines: 3,
                              maxLines: 5,
                              decoration: _inputDecoration(label: 'Bio', icon: Icons.info_outline),
                              validator: (value) {
                                if (value != null && value.length > 500) {
                                  return 'Bio must be 500 characters or less';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.gap6,
                            AppButton(
                              text: 'Save Additional Info',
                              onPressed: _isSaving ? null : _saveAdditionalInfo,
                              isLoading: _isSaving,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}