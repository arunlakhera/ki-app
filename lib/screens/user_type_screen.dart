import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});
  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String _selected = 'worker';

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Who are you?', style: TextStyle(color: tc.textWhite, fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Select your account type to get started', style: TextStyle(color: tc.textGrey, fontSize: 14)),
            const SizedBox(height: 36),
            _TypeCard(
              selected: _selected == 'worker',
              icon: Icons.construction_rounded,
              title: 'Skilled Worker',
              subtitle: 'Find jobs, build your profile and earn through your skills.',
              onTap: () => setState(() => _selected = 'worker'),
              tc: tc, primary: primary,
            ),
            const SizedBox(height: 16),
            _TypeCard(
              selected: _selected == 'employer',
              icon: Icons.business_center_rounded,
              title: 'Employer / Contractor',
              subtitle: 'Post jobs, find skilled workers and manage your projects.',
              onTap: () => setState(() => _selected = 'employer'),
              tc: tc, primary: primary,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('CONTINUE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final AppThemeColors tc;
  final Color primary;
  const _TypeCard({required this.selected, required this.icon, required this.title,
      required this.subtitle, required this.onTap, required this.tc, required this.primary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.08) : tc.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? primary : tc.borderColor, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: selected ? primary.withValues(alpha: 0.15) : tc.inputBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: selected ? primary : tc.textGrey, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: tc.textWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: tc.textGrey, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? primary : Colors.transparent,
                border: Border.all(color: selected ? primary : tc.borderColor, width: 2),
              ),
              child: selected ? const Icon(Icons.check, color: Colors.white, size: 13) : null,
            ),
          ],
        ),
      ),
    );
  }
}
