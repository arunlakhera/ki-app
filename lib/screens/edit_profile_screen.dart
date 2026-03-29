import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Rahul Sharma');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _cityController = TextEditingController(text: 'Mumbai');
  final _bioController = TextEditingController(text: '5+ years of experience in electrical work.');

  @override
  void dispose() {
    _nameController.dispose(); _phoneController.dispose();
    _cityController.dispose(); _bioController.dispose();
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
        title: Text('Edit Profile', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Avatar
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: primary.withValues(alpha: 0.2),
                    child: Text('RS', style: TextStyle(color: primary, fontSize: 30, fontWeight: FontWeight.w800)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _label('FULL NAME', primary),
            const SizedBox(height: 8),
            _field(controller: _nameController, tc: tc, icon: Icons.person_outline),
            const SizedBox(height: 20),
            _label('MOBILE NUMBER', primary),
            const SizedBox(height: 8),
            _field(controller: _phoneController, tc: tc, icon: Icons.phone_outlined, readOnly: true),
            const SizedBox(height: 20),
            _label('CITY / DISTRICT', primary),
            const SizedBox(height: 8),
            _field(controller: _cityController, tc: tc, icon: Icons.location_on_outlined),
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
                  value: 'Electrician',
                  isExpanded: true,
                  dropdownColor: tc.cardBackground,
                  style: TextStyle(color: tc.textWhite, fontSize: 15),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: tc.textGrey),
                  items: ['Electrician', 'Plumber', 'Carpenter', 'Welder', 'Painter', 'Mason']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (_) {},
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
                  value: '5+ Years',
                  isExpanded: true,
                  dropdownColor: tc.cardBackground,
                  style: TextStyle(color: tc.textWhite, fontSize: 15),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: tc.textGrey),
                  items: ['< 1 Year', '1-2 Years', '3-5 Years', '5+ Years', '10+ Years']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, Color primary) =>
      Text(text, style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2));

  Widget _field({required TextEditingController controller, required AppThemeColors tc, required IconData icon, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: tc.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.borderColor),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(color: readOnly ? tc.textGrey : tc.textWhite, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: tc.textGrey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        ),
      ),
    );
  }
}
