import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final _searchController = TextEditingController();
  String _activeFilter = 'NearMe';

  final List<Map<String, dynamic>> _jobs = [
    {
      'title': 'Senior Welder',
      'company': 'Tata Projects',
      'location': 'Mumbai',
      'salary': '₹35,000/mo',
      'salaryType': 'SALARY',
      'posted': '2 days ago',
      'verified': true,
      'icon': Icons.precision_manufacturing_outlined,
      'iconColor': const Color(0xFF0EA5E9),
      'iconBg': const Color(0xFF0C2340),
    },
    {
      'title': 'House Electrician',
      'company': 'Gopal Housing',
      'location': 'Pune',
      'salary': '₹1,200/day',
      'salaryType': 'DAILY RATE',
      'posted': '5 hours ago',
      'verified': false,
      'icon': Icons.electric_bolt_outlined,
      'iconColor': const Color(0xFF10B981),
      'iconBg': const Color(0xFF0A2E20),
    },
    {
      'title': 'Master Carpenter',
      'company': 'WoodWorks Furniture',
      'location': 'Bengaluru',
      'salary': '₹40,000/mo',
      'salaryType': 'SALARY',
      'posted': '1 week ago',
      'verified': true,
      'icon': Icons.carpenter_outlined,
      'iconColor': const Color(0xFFF59E0B),
      'iconBg': const Color(0xFF2E1A06),
    },
    {
      'title': 'Site Supervisor',
      'company': 'Prestige Constructions',
      'location': 'Hyderabad',
      'salary': '₹55,000/mo',
      'salaryType': 'SALARY',
      'posted': '3 days ago',
      'verified': true,
      'icon': Icons.construction_outlined,
      'iconColor': const Color(0xFF8B5CF6),
      'iconBg': const Color(0xFF1E0D3B),
    },
    {
      'title': 'AC Technician',
      'company': 'CoolAir Services',
      'location': 'Chennai',
      'salary': '₹900/day',
      'salaryType': 'DAILY RATE',
      'posted': '1 day ago',
      'verified': false,
      'icon': Icons.air_outlined,
      'iconColor': const Color(0xFF06B6D4),
      'iconBg': const Color(0xFF092330),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.search, color: tc.textGrey, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Explore Jobs',
                      style: TextStyle(
                        color: tc.textWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    child: Text(
                      'RS',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: tc.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tc.borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: tc.textWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search jobs, skills, locations',
                    hintStyle: TextStyle(color: tc.textGrey, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: tc.textGrey,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterButton(
                    label: 'Near Me',
                    icon: Icons.near_me_rounded,
                    selected: _activeFilter == 'NearMe',
                    onTap: () => setState(() => _activeFilter = 'NearMe'),
                  ),
                  const SizedBox(width: 10),
                  _FilterButton(
                    label: 'High Paying',
                    selected: _activeFilter == 'HighPaying',
                    onTap: () => setState(() => _activeFilter = 'HighPaying'),
                  ),
                  const SizedBox(width: 10),
                  _FilterButton(
                    label: 'Immediate Join',
                    selected: _activeFilter == 'Immediate',
                    onTap: () => setState(() => _activeFilter = 'Immediate'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _jobs.length,
                itemBuilder: (context, i) => _JobListCard(job: _jobs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  const _FilterButton({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? primary : tc.cardBackground,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? primary : tc.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : tc.textGrey,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : tc.textGrey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobListCard extends StatelessWidget {
  final Map<String, dynamic> job;
  const _JobListCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: tc.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tc.borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: job['iconBg'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  job['icon'] as IconData,
                  color: job['iconColor'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          job['title'] as String,
                          style: TextStyle(
                            color: tc.textWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (job['verified'] as bool) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
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
                      '${job['company']} • ${job['location']}',
                      style: TextStyle(color: tc.textGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.bookmark_border_rounded, color: tc.textGrey, size: 20),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['salaryType'] as String,
                      style: TextStyle(
                        color: tc.textGrey,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job['salary'] as String,
                      style: TextStyle(
                        color: secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'POSTED',
                      style: TextStyle(
                        color: tc.textGrey,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job['posted'] as String,
                      style: TextStyle(color: tc.textGreyLight, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tc.inputBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: tc.borderColor),
                ),
                child: Icon(Icons.share_outlined, color: tc.textGrey, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
