import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';
import '../main.dart' show themeNotifier;
import '../services/auth_service.dart';
import '../services/messaging_service.dart';
import '../models/user_model.dart';
import 'jobs_screen.dart';
import 'community_screen.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});
  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _currentIndex = 0;
  final _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    _messagingService.initialize();
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return const _HomeTab();
      case 1:
        return const JobsScreen();
      case 2:
        return const CommunityScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: _buildPage(),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              ),
              backgroundColor: primary,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: tc.navBar,
          border: Border(top: BorderSide(color: tc.borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: primary,
            unselectedItemColor: tc.textGrey,
            selectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline_rounded),
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AppBar row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'KI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: TextStyle(color: tc.textGrey, fontSize: 12),
                      ),
                      StreamBuilder<UserModel?>(
                        stream: AuthService().userProfileStream(),
                        builder: (context, snap) {
                          final name = snap.data?.name ?? 'User';
                          return Text(
                            name.split(' ').first,
                            style: TextStyle(
                              color: tc.textWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) {
                    final isDark = mode == ThemeMode.dark;
                    return IconButton(
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: tc.textWhite,
                      ),
                      tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                      onPressed: () => themeNotifier.value = isDark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: tc.textWhite),
                  onPressed: () {},
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: primary.withValues(alpha: 0.2),
                  child: Text(
                    'RS',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [tertiary, tertiary.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PREMIUM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Premium Safety\nCertification Course',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Get certified, earn more',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: tertiary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_user_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.bolt,
                          iconColor: tertiary,
                          value: '3',
                          label: 'ACTIVE JOBS',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.credit_card_outlined,
                          iconColor: primary,
                          value: '12',
                          label: 'CREDITS LEFT',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Profile strength
                  Container(
                    decoration: BoxDecoration(
                      color: tc.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROFILE STRENGTH',
                                style: TextStyle(
                                  color: tc.textGrey,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '70%\nComplete',
                                style: TextStyle(
                                  color: tc.textWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: 0.7,
                                  backgroundColor: tc.borderColor,
                                  valueColor: AlwaysStoppedAnimation(primary),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Finish\nNow',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Section tabs
                  Row(
                    children: [
                      _SectionTab(label: 'Feed', active: true),
                      const SizedBox(width: 20),
                      _SectionTab(label: 'Jobs', active: false),
                      const SizedBox(width: 20),
                      _SectionTab(label: 'My Posts', active: false),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: _activeFilter == 'All',
                          onTap: () => setState(() => _activeFilter = 'All'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Nearby',
                          selected: _activeFilter == 'Nearby',
                          onTap: () => setState(() => _activeFilter = 'Nearby'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'My Skills',
                          selected: _activeFilter == 'My Skills',
                          onTap: () =>
                              setState(() => _activeFilter = 'My Skills'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Job cards
                  _JobCard(
                    company: 'Tata Housing Ltd.',
                    location: 'Mumbai, Maharashtra',
                    time: '4h ago',
                    verified: true,
                    title: 'Senior Electrical Foreman',
                    description:
                        'Required for large-scale residential project in Worli. Must have 5+ years experience.',
                    salary: '₹45,000 / month',
                    onApply: () {},
                  ),
                  const SizedBox(height: 12),
                  _JobCard(
                    company: 'L&T Constructions',
                    location: 'Navi Mumbai',
                    time: '5h ago',
                    verified: true,
                    title: 'Safety Inspector (Civil)',
                    description:
                        'Supervising safety protocols at highway expansion site. Industrial certification required.',
                    salary: '₹52,000 / month',
                    onApply: () {},
                  ),
                  const SizedBox(height: 12),
                  // Featured card
                  Container(
                    decoration: BoxDecoration(
                      color: tc.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: tertiary.withValues(alpha: 0.4),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: tertiary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: tertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'FEATURED OPPORTUNITY',
                              style: TextStyle(
                                color: tertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Project Lead –\nElectrical Systems',
                          style: TextStyle(
                            color: tc.textWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take the lead on our flagship smart city project. High growth potential and performance bonuses included.',
                          style: TextStyle(
                            color: tc.textGrey,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              color: secondary,
                              size: 14,
                            ),
                            Text(
                              '85K+',
                              style: TextStyle(
                                color: secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.location_on_outlined,
                              color: tc.textGrey,
                              size: 14,
                            ),
                            Text(
                              'Pune',
                              style: TextStyle(
                                color: tc.textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: tc.borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              color: tc.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Tab ──────────────────────────────────────────────────────────────

class _SectionTab extends StatelessWidget {
  final String label;
  final bool active;
  const _SectionTab({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: active ? tc.textWhite : tc.textGrey,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        if (active)
          Container(
            height: 2,
            width: label.length * 7.0,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _FilterChip({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primary : tc.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? primary : tc.borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : tc.textGrey,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value, label;
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Container(
      decoration: BoxDecoration(
        color: tc.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: tc.textWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: tc.textGrey,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────

class _JobCard extends StatelessWidget {
  final String company, location, time, title, description, salary;
  final bool verified;
  final VoidCallback onApply;
  const _JobCard({
    required this.company,
    required this.location,
    required this.time,
    required this.verified,
    required this.title,
    required this.description,
    required this.salary,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        color: tc.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tc.borderColor),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tc.inputBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.business, color: tc.textGrey, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            company,
                            style: TextStyle(
                              color: tc.textWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: secondary,
                                  size: 10,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    color: secondary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '$location • $time',
                      style: TextStyle(color: tc.textGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.bookmark_border_rounded, color: tc.textGrey, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: tc.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: tc.textGrey, fontSize: 12, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPECTED RATE',
                      style: TextStyle(
                        color: tc.textGrey,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      salary,
                      style: TextStyle(
                        color: secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Apply\nNow',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
