import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: tc.textWhite),
          onPressed: () {},
        ),
        title: Text('Community',
            style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: tc.textWhite), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: primary,
              child: const Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _TabItem(label: 'Feed', active: _activeTab == 0, onTap: () => setState(() => _activeTab = 0)),
                const SizedBox(width: 24),
                _TabItem(label: 'My Posts', active: _activeTab == 1, onTap: () => setState(() => _activeTab = 1)),
                const SizedBox(width: 24),
                _TabItem(label: 'Saved', active: _activeTab == 2, onTap: () => setState(() => _activeTab = 2)),
              ],
            ),
          ),
          Divider(color: tc.divider, height: 1),
          Expanded(
            child: _activeTab == 0
                ? const _FeedTab()
                : _EmptyTab(label: _activeTab == 1 ? 'No posts yet' : 'No saved posts'),
          ),
        ],
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _PostCard(
          name: 'Rajesh Construction',
          subtitle: '2 hours ago • Mumbai',
          text: 'Proud to finish this 3BHK project in Mumbai. Great team effort!',
          avatarColor: const Color(0xFF7C3AED),
          avatarInitials: 'RC',
          hasImage: true,
          imageGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A3A1A), Color(0xFF0D2030)],
          ),
          imageIcon: Icons.construction_rounded,
          imageLabel: '3BHK Project • Mumbai',
          likes: 24,
          comments: 8,
          verified: false,
        ),
        const SizedBox(height: 14),
        _PostCard(
          name: 'Amit Singh',
          subtitle: 'Skilled Electrician • 5h ago',
          text: 'Available for residential wiring work in Pune next week. 5 years exp.',
          avatarColor: const Color(0xFF0369A1),
          avatarInitials: 'AS',
          hasImage: false,
          likes: 0,
          comments: 0,
          verified: true,
          hasActionButton: true,
        ),
        const SizedBox(height: 14),
        const _OfficialPostCard(),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final String label;
  const _EmptyTab({required this.label});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, color: context.tc.textGrey, size: 48),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: context.tc.textGrey, fontSize: 15)),
        ],
      ),
    );
  }
}

class _OfficialPostCard extends StatelessWidget {
  const _OfficialPostCard();
  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: tc.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tc.borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0C1F4A), Color(0xFF0A3566)],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shield_rounded, color: Color(0xFF1E3A7A), size: 52),
                  Icon(Icons.verified_user_rounded, color: primary, size: 28),
                  Positioned(
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(4)),
                      child: const Text('KI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 9)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: primary, size: 10),
                      const SizedBox(width: 3),
                      Text('OFFICIAL', style: TextStyle(color: primary, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('New Safety Certification course now available.',
                    style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 3),
                Text('Enhance your professional standing today.',
                    style: TextStyle(color: tc.textGrey, fontSize: 12)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Text('Learn More →', style: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabItem({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                  color: active ? primary : context.tc.textGrey,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 15,
                )),
            const SizedBox(height: 8),
            if (active)
              Container(
                height: 2,
                width: label.length * 7.5,
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2)),
              ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final String name;
  final String subtitle;
  final String text;
  final Color avatarColor;
  final String avatarInitials;
  final bool hasImage;
  final Gradient? imageGradient;
  final IconData imageIcon;
  final String imageLabel;
  final int likes;
  final int comments;
  final bool verified;
  final bool hasActionButton;

  const _PostCard({
    required this.name, required this.subtitle, required this.text,
    this.avatarColor = AppColors.inputBackground, this.avatarInitials = '',
    required this.hasImage, this.imageGradient,
    this.imageIcon = Icons.image_outlined, this.imageLabel = '',
    required this.likes, required this.comments,
    required this.verified, this.hasActionButton = false,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int _likes;
  bool _liked = false;

  @override
  void initState() { super.initState(); _likes = widget.likes; }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        color: tc.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tc.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22, backgroundColor: widget.avatarColor,
                  child: widget.avatarInitials.isNotEmpty
                      ? Text(widget.avatarInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))
                      : const Icon(Icons.person, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(child: Text(widget.name,
                            style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 14))),
                        if (widget.verified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: secondary.withValues(alpha: 0.3)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.verified_rounded, color: secondary, size: 10),
                              const SizedBox(width: 3),
                              Text('VERIFIED', style: TextStyle(color: secondary, fontSize: 9, fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ],
                      ]),
                      Text(widget.subtitle, style: TextStyle(color: tc.textGrey, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(widget.hasActionButton ? Icons.bookmark_border_rounded : Icons.more_vert,
                    color: tc.textGrey, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(widget.text, style: TextStyle(color: tc.textWhite, fontSize: 14, height: 1.5)),
          ),
          if (widget.hasImage) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                  gradient: widget.imageGradient ?? const LinearGradient(
                    colors: [Color(0xFF1A2840), Color(0xFF0D1520)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(children: [
                  Positioned.fill(child: CustomPaint(painter: _DotPatternPainter())),
                  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.foundation, color: Colors.white.withValues(alpha: 0.15), size: 90),
                      const SizedBox(width: 4),
                      Icon(widget.imageIcon, color: Colors.white.withValues(alpha: 0.65), size: 60),
                    ]),
                    if (widget.imageLabel.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(6)),
                        child: Text(widget.imageLabel, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ])),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.location_on, color: Colors.white70, size: 11),
                        SizedBox(width: 3),
                        Text('Mumbai, MH', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ],
          if (widget.hasActionButton) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Portfolio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: tc.inputBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: tc.borderColor),
                  ),
                  child: Icon(Icons.email_outlined, color: tc.textGrey, size: 18),
                ),
              ]),
            ),
          ],
          if (!widget.hasActionButton && widget.likes > 0) ...[
            const SizedBox(height: 10),
            Divider(color: tc.divider, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                GestureDetector(
                  onTap: () => setState(() { _liked = !_liked; _likes += _liked ? 1 : -1; }),
                  child: Row(children: [
                    Icon(_liked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                        color: _liked ? primary : tc.textGrey, size: 18),
                    const SizedBox(width: 5),
                    Text('$_likes', style: TextStyle(color: tc.textGrey, fontSize: 13)),
                  ]),
                ),
                const SizedBox(width: 18),
                Icon(Icons.chat_bubble_outline_rounded, color: tc.textGrey, size: 18),
                const SizedBox(width: 5),
                Text('${widget.comments}', style: TextStyle(color: tc.textGrey, fontSize: 13)),
                const Spacer(),
                Icon(Icons.share_outlined, color: tc.textGrey, size: 18),
              ]),
            ),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.04)..style = PaintingStyle.fill;
    const spacing = 18.0; const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing)
      for (double y = 0; y < size.height; y += spacing)
        canvas.drawCircle(Offset(x, y), radius, paint);
  }
  @override bool shouldRepaint(_DotPatternPainter old) => false;
}
