import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded, color: secondary, size: 60),
              ),
              const SizedBox(height: 28),
              Text('You\'re Verified!', style: TextStyle(color: tc.textWhite, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(
                'Your KI account is ready. Start exploring jobs and connect with employers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: tc.textGrey, fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 32),
              // Highlights
              _HighlightRow(icon: Icons.work_outline_rounded, label: 'Browse 500+ jobs near you', tc: tc, primary: primary),
              const SizedBox(height: 14),
              _HighlightRow(icon: Icons.verified_user_outlined, label: 'Build your verified profile', tc: tc, primary: primary),
              const SizedBox(height: 14),
              _HighlightRow(icon: Icons.currency_rupee_rounded, label: 'Get paid directly via KI Credits', tc: tc, primary: primary),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/worker-home', (r) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('EXPLORE JOBS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/worker-home', (r) => false, arguments: 'profile'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: tc.borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('COMPLETE MY PROFILE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tc.textWhite, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppThemeColors tc;
  final Color primary;
  const _HighlightRow({required this.icon, required this.label, required this.tc, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: primary, size: 20),
      ),
      const SizedBox(width: 14),
      Expanded(child: Text(label, style: TextStyle(color: tc.textWhite, fontSize: 14, fontWeight: FontWeight.w500))),
    ]);
  }
}
