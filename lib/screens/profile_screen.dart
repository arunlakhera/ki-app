import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Profile', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(icon: Icon(Icons.settings_outlined, color: tc.textWhite), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(color: tc.cardBackground),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: primary.withValues(alpha: 0.2),
                        child: Text('RS', style: TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.w800)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Rahul Sharma', style: TextStyle(color: tc.textWhite, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Senior Electrician • Mumbai', style: TextStyle(color: tc.textGrey, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: secondary.withValues(alpha: 0.3)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.verified_rounded, color: secondary, size: 13),
                          const SizedBox(width: 4),
                          Text('KI VERIFIED', style: TextStyle(color: secondary, fontSize: 11, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.star_rounded, color: primary, size: 13),
                          const SizedBox(width: 4),
                          Text('4.8 Rating', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                          icon: Icon(Icons.edit_outlined, size: 16, color: primary),
                          label: Text('Edit Profile', style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, size: 16, color: Colors.white),
                          label: const Text('Share', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Stats
            Container(
              color: tc.cardBackground,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _StatItem(value: '47', label: 'Jobs Done', color: primary),
                  _divider(tc),
                  _StatItem(value: '12', label: 'Credits', color: secondary),
                  _divider(tc),
                  _StatItem(value: '3', label: 'Active', color: const Color(0xFFFF5A1F)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Skills
            _Section(
              title: 'Skills',
              tc: tc,
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: ['Electrical Wiring', 'Panel Installation', 'Solar Setup', 'AC Repair', 'Plumbing']
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary.withValues(alpha: 0.3)),
                          ),
                          child: Text(s, style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            // About
            _Section(
              title: 'About',
              tc: tc,
              child: Text(
                '5+ years of experience in electrical work. Specialized in residential and commercial wiring, solar panel installations and AC repair.',
                style: TextStyle(color: tc.textGreyLight, fontSize: 13, height: 1.6),
              ),
            ),
            const SizedBox(height: 8),
            // Menu items
            Container(
              color: tc.cardBackground,
              child: Column(
                children: [
                  _MenuItem(icon: Icons.work_history_outlined, label: 'Work History', tc: tc, primary: primary),
                  Divider(color: tc.divider, height: 1, indent: 56),
                  _MenuItem(icon: Icons.reviews_outlined, label: 'Reviews', tc: tc, primary: primary),
                  Divider(color: tc.divider, height: 1, indent: 56),
                  _MenuItem(icon: Icons.credit_card_outlined, label: 'KI Credits', tc: tc, primary: primary),
                  Divider(color: tc.divider, height: 1, indent: 56),
                  _MenuItem(icon: Icons.logout_rounded, label: 'Log Out', tc: tc, primary: const Color(0xFFE02424), isDestructive: true),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _divider(AppThemeColors tc) => Container(width: 1, height: 36, color: tc.borderColor);
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: context.tc.textGrey, fontSize: 11)),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final AppThemeColors tc;
  const _Section({required this.title, required this.child, required this.tc});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: tc.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: tc.textWhite, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppThemeColors tc;
  final Color primary;
  final bool isDestructive;
  const _MenuItem({required this.icon, required this.label, required this.tc, required this.primary, this.isDestructive = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: (isDestructive ? const Color(0xFFE02424) : primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? const Color(0xFFE02424) : primary, size: 18),
      ),
      title: Text(label, style: TextStyle(color: isDestructive ? const Color(0xFFE02424) : tc.textWhite, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: isDestructive ? null : Icon(Icons.chevron_right, color: tc.textGrey, size: 20),
      onTap: () {},
    );
  }
}
