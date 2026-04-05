import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme_colors.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _authService = AuthService();
  final _storageService = StorageService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedSkill = 'Electrician';
  String _selectedExp = '1-2 Years';
  File? _newAvatar;
  String? _currentAvatarUrl;
  bool _saving = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await _authService.getUserProfile();
    if (user != null && mounted) {
      setState(() {
        _nameController.text = user.name;
        _phoneController.text = user.phone;
        _cityController.text = user.location ?? '';
        _bioController.text = user.bio ?? '';
        _currentAvatarUrl = user.profileImageUrl;
        if (user.skills.isNotEmpty) _selectedSkill = user.skills.first;
        _loaded = true;
      });
    } else {
      setState(() => _loaded = true);
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) {
      setState(() => _newAvatar = File(picked.path));
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      String? avatarUrl = _currentAvatarUrl;
      if (_newAvatar != null) {
        avatarUrl = await _storageService.uploadProfileImage(_newAvatar!);
      }
      await _authService.updateUserProfile({
        'name': _nameController.text.trim(),
        'location': _cityController.text.trim(),
        'bio': _bioController.text.trim(),
        'skills': [_selectedSkill],
        'profileImageUrl': avatarUrl,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save profile.'),
            backgroundColor: const Color(0xFFE02424),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tc.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: tc.textWhite,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: primary.withValues(alpha: 0.2),
                            backgroundImage: _newAvatar != null
                                ? FileImage(_newAvatar!)
                                : (_currentAvatarUrl != null
                                      ? NetworkImage(_currentAvatarUrl!)
                                      : null),
                            child:
                                (_newAvatar == null &&
                                    _currentAvatarUrl == null)
                                ? Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _label('FULL NAME', primary),
                  const SizedBox(height: 8),
                  _field(
                    controller: _nameController,
                    tc: tc,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  _label('MOBILE NUMBER', primary),
                  const SizedBox(height: 8),
                  _field(
                    controller: _phoneController,
                    tc: tc,
                    icon: Icons.phone_outlined,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  _label('CITY / DISTRICT', primary),
                  const SizedBox(height: 8),
                  _field(
                    controller: _cityController,
                    tc: tc,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),
                  _label('BIO', primary),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: tc.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tc.borderColor),
                    ),
                    child: TextField(
                      controller: _bioController,
                      maxLines: 4,
                      style: TextStyle(color: tc.textWhite, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Tell employers about your experience...',
                        hintStyle: TextStyle(color: tc.textGrey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _label('PRIMARY SKILL', primary),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: tc.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tc.borderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSkill,
                        isExpanded: true,
                        dropdownColor: tc.cardBackground,
                        style: TextStyle(color: tc.textWhite, fontSize: 15),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: tc.textGrey,
                        ),
                        items:
                            [
                                  'Electrician',
                                  'Plumber',
                                  'Carpenter',
                                  'Welder',
                                  'Painter',
                                  'Mason',
                                ]
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(
                          () => _selectedSkill = v ?? _selectedSkill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _label('YEARS OF EXPERIENCE', primary),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: tc.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tc.borderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedExp,
                        isExpanded: true,
                        dropdownColor: tc.cardBackground,
                        style: TextStyle(color: tc.textWhite, fontSize: 15),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: tc.textGrey,
                        ),
                        items:
                            [
                                  '< 1 Year',
                                  '1-2 Years',
                                  '3-5 Years',
                                  '5+ Years',
                                  '10+ Years',
                                ]
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedExp = v ?? _selectedExp),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _label(String text, Color primary) => Text(
    text,
    style: TextStyle(
      color: primary,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required AppThemeColors tc,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: tc.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.borderColor),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          color: readOnly ? tc.textGrey : tc.textWhite,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: tc.textGrey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
