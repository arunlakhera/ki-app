import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  bool _isLookingForWork = false;

  @override
  void dispose() { _postController.dispose(); super.dispose(); }

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
        title: Text('Create Post', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 18)),
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
              child: const Text('POST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: primary.withValues(alpha: 0.2),
                    child: Text('RS', style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      maxLines: 6,
                      style: TextStyle(color: tc.textWhite, fontSize: 15, height: 1.5),
                      decoration: InputDecoration(
                        hintText: "Share your work, availability, or a project update...",
                        hintStyle: TextStyle(color: tc.textGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: tc.divider, height: 1),
            // Looking for work toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.work_outline_rounded, color: primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available for Work', style: TextStyle(color: tc.textWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('Show employers you are open to hire', style: TextStyle(color: tc.textGrey, fontSize: 12)),
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
              icon: Icons.image_outlined,
              iconColor: primary,
              label: 'Add Photo',
              tc: tc,
              trailing: Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: () {},
            ),
            Divider(color: tc.divider, height: 1, indent: 56),
            _OptionTile(
              icon: Icons.location_on_outlined,
              iconColor: primary,
              label: 'Tag Location',
              tc: tc,
              trailing: Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: () {},
            ),
            Divider(color: tc.divider, height: 1, indent: 56),
            _OptionTile(
              icon: Icons.build_outlined,
              iconColor: primary,
              label: 'Tag Skills',
              tc: tc,
              trailing: Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
              onTap: () {},
            ),
            Divider(color: tc.divider, height: 1),
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
    required this.icon, required this.iconColor, required this.label,
    required this.trailing, required this.onTap, required this.tc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(color: tc.textWhite, fontSize: 14))),
          trailing,
        ]),
      ),
    );
  }
}
