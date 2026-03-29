import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    return Scaffold(
      body: Column(
        children: [
          // Top section — logo & tagline
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primary.withValues(alpha: 0.15),
                    tc.background,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: primary.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: const Center(
                        child: Text('KI', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('KI Platform', style: TextStyle(color: tc.textWhite, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 8),
                    Text('Earn Through Your Skills', style: TextStyle(color: tc.textGrey, fontSize: 15)),
                    const SizedBox(height: 32),
                    // Feature pills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Pill(label: '500+ Jobs', icon: Icons.work_outline_rounded, color: primary),
                        const SizedBox(width: 10),
                        _Pill(label: 'Verified', icon: Icons.verified_rounded, color: tertiary),
                        const SizedBox(width: 10),
                        _Pill(label: 'Instant Pay', icon: Icons.currency_rupee_rounded, color: Theme.of(context).colorScheme.secondary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom section — CTA buttons
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: tc.cardBackground,
              border: Border(top: BorderSide(color: tc.borderColor)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Join thousands of skilled workers', style: TextStyle(color: tc.textWhite, fontSize: 17, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Find jobs near you and get paid faster', style: TextStyle(color: tc.textGrey, fontSize: 13), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/user-type'),
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
                          Text('GET STARTED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: tc.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('LOG IN TO MY ACCOUNT',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tc.textWhite, letterSpacing: 0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Pill({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
