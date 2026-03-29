import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme_colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  bool _isLookingForWork = false;
  String? _location;
  List<String> _selectedSkills = [];
  File? _selectedImage;

  static const _locations = [
    'Mumbai',
    'Pune',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Ahmedabad',
  ];
  static const _allSkills = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Welder',
    'Painter',
    'Mason',
    'AC Repair',
    'Solar Install',
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  // ── Photo Picker ─────────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
      );
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}. Please check permissions in Settings.',
            ),
            backgroundColor: context.tc.cardBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showPhotoSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.tc.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final tc = ctx.tc;
        final primary = Theme.of(ctx).colorScheme.primary;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: tc.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: tc.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: primary,
                      tc: tc,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: primary,
                      tc: tc,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _selectedImage = null);
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const Text('Remove Photo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE02424),
                      side: const BorderSide(color: Color(0xFFE02424)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── Location Picker ──────────────────────────────────────────────────────────

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.tc.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          final tc = ctx.tc;
          final primary = Theme.of(ctx).colorScheme.primary;
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tc.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Tag Location',
                    style: TextStyle(
                      color: tc.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _locations
                        .map(
                          (loc) => ListTile(
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: primary,
                              size: 20,
                            ),
                            title: Text(
                              loc,
                              style: TextStyle(
                                color: tc.textWhite,
                                fontSize: 14,
                              ),
                            ),
                            trailing: _location == loc
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: primary,
                                    size: 20,
                                  )
                                : null,
                            onTap: () {
                              setState(() => _location = loc);
                              Navigator.pop(ctx);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Skills Picker ────────────────────────────────────────────────────────────

  void _showSkillsPicker() {
    final temp = List<String>.from(_selectedSkills);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.tc.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          final tc = ctx.tc;
          final primary = Theme.of(ctx).colorScheme.primary;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tc.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tag Skills',
                  style: TextStyle(
                    color: tc.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allSkills.map((s) {
                    final sel = temp.contains(s);
                    return GestureDetector(
                      onTap: () =>
                          setInner(() => sel ? temp.remove(s) : temp.add(s)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? primary.withValues(alpha: 0.15)
                              : tc.inputBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: sel ? primary : tc.borderColor,
                          ),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(
                            color: sel ? primary : tc.textGrey,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _selectedSkills = List.from(temp));
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Preview & Confirm ────────────────────────────────────────────────────────

  void _showPreviewAndConfirm() {
    final tc = context.tc;
    final text = _postController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please write something before posting.'),
          backgroundColor: tc.cardBackground,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tc.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final tc = ctx.tc;
        final primary = Theme.of(ctx).colorScheme.primary;
        final secondary = Theme.of(ctx).colorScheme.secondary;
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.88,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tc.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.preview_rounded, color: primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Post Preview',
                      style: TextStyle(
                        color: tc.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: tc.divider, height: 1),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preview card
                      Container(
                        decoration: BoxDecoration(
                          color: tc.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: tc.borderColor),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        child: Text(
                                          'RS',
                                          style: TextStyle(
                                            color: primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rahul Sharma',
                                              style: TextStyle(
                                                color: tc.textWhite,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Just now',
                                              style: TextStyle(
                                                color: tc.textGrey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    text,
                                    style: TextStyle(
                                      color: tc.textWhite,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  if (_location != null ||
                                      _selectedSkills.isNotEmpty ||
                                      _isLookingForWork) ...[
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        if (_isLookingForWork)
                                          _PreviewTag(
                                            label: '🟢 Available for Work',
                                            color: secondary,
                                          ),
                                        if (_location != null)
                                          _PreviewTag(
                                            label: '📍 $_location',
                                            color: primary,
                                          ),
                                        ..._selectedSkills.map(
                                          (s) => _PreviewTag(
                                            label: '🔧 $s',
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Photo preview
                            if (_selectedImage != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Summary
                      Text(
                        'Post Details',
                        style: TextStyle(
                          color: tc.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: tc.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: tc.borderColor),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _SummaryRow(
                              icon: Icons.image_outlined,
                              label: 'Photo',
                              value: _selectedImage != null
                                  ? 'Attached'
                                  : 'No photo',
                              color: _selectedImage != null
                                  ? secondary
                                  : tc.textGrey,
                              tc: tc,
                            ),
                            Divider(color: tc.divider, height: 20),
                            _SummaryRow(
                              icon: Icons.work_outline_rounded,
                              label: 'Available for Work',
                              value: _isLookingForWork ? 'Yes' : 'No',
                              color: _isLookingForWork
                                  ? secondary
                                  : tc.textGrey,
                              tc: tc,
                            ),
                            Divider(color: tc.divider, height: 20),
                            _SummaryRow(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: _location ?? 'Not tagged',
                              color: _location != null ? primary : tc.textGrey,
                              tc: tc,
                            ),
                            Divider(color: tc.divider, height: 20),
                            _SummaryRow(
                              icon: Icons.build_outlined,
                              label: 'Skills',
                              value: _selectedSkills.isEmpty
                                  ? 'None tagged'
                                  : _selectedSkills.join(', '),
                              color: _selectedSkills.isNotEmpty
                                  ? primary
                                  : tc.textGrey,
                              tc: tc,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer buttons
              Divider(color: tc.divider, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: tc.borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: tc.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Post published successfully!'),
                                ],
                              ),
                              backgroundColor: tc.cardBackground,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          'Confirm & Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: tc.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Post',
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
              onPressed: _showPreviewAndConfirm,
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
              child: const Text(
                'POST',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text input
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: primary.withValues(alpha: 0.2),
                    child: Text(
                      'RS',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      maxLines: 6,
                      style: TextStyle(
                        color: tc.textWhite,
                        fontSize: 15,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Share your work, availability, or a project update...",
                        hintStyle: TextStyle(color: tc.textGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Selected photo thumbnail
            if (_selectedImage != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedImage = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Divider(color: tc.divider, height: 1),
            // Available for work toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.work_outline_rounded,
                      color: primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available for Work',
                          style: TextStyle(
                            color: tc.textWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Show employers you are open to hire',
                          style: TextStyle(color: tc.textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isLookingForWork,
                    activeColor: primary,
                    inactiveTrackColor: tc.borderColor,
                    onChanged: (v) => setState(() => _isLookingForWork = v),
                  ),
                ],
              ),
            ),
            Divider(color: tc.divider, height: 1),
            _OptionTile(
              icon: _selectedImage != null
                  ? Icons.image_rounded
                  : Icons.image_outlined,
              iconColor: _selectedImage != null
                  ? Theme.of(context).colorScheme.secondary
                  : primary,
              label: _selectedImage != null ? 'Photo Added ✓' : 'Add Photo',
              tc: tc,
              trailing: _selectedImage != null
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    )
                  : Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: _showPhotoSourcePicker,
            ),
            Divider(color: tc.divider, height: 1, indent: 56),
            _OptionTile(
              icon: Icons.location_on_outlined,
              iconColor: primary,
              label: _location != null
                  ? 'Location: $_location'
                  : 'Tag Location',
              tc: tc,
              trailing: _location != null
                  ? Icon(Icons.check_circle_rounded, color: primary, size: 20)
                  : Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: _showLocationPicker,
            ),
            Divider(color: tc.divider, height: 1, indent: 56),
            _OptionTile(
              icon: Icons.build_outlined,
              iconColor: primary,
              label: _selectedSkills.isEmpty
                  ? 'Tag Skills'
                  : 'Skills: ${_selectedSkills.join(', ')}',
              tc: tc,
              trailing: _selectedSkills.isNotEmpty
                  ? Icon(Icons.check_circle_rounded, color: primary, size: 20)
                  : Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: _showSkillsPicker,
            ),
            Divider(color: tc.divider, height: 1),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final AppThemeColors tc;
  final VoidCallback onTap;
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.tc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: tc.textWhite,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;
  final AppThemeColors tc;
  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
    required this.onTap,
    required this.tc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: tc.textWhite, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _PreviewTag extends StatelessWidget {
  final String label;
  final Color color;
  const _PreviewTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final AppThemeColors tc;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.tc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(color: tc.textGrey, fontSize: 13)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
