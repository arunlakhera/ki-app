import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/post_model.dart';

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
        title: Text('Community', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: tc.textWhite), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: primary.withValues(alpha: 0.2),
              child: Text('RS', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _TabItem(label: 'Feed', active: _activeTab == 0, onTap: () => setState(() => _activeTab = 0)),
              const SizedBox(width: 24),
              _TabItem(label: 'My Posts', active: _activeTab == 1, onTap: () => setState(() => _activeTab = 1)),
              const SizedBox(width: 24),
              _TabItem(label: 'Saved', active: _activeTab == 2, onTap: () => setState(() => _activeTab = 2)),
            ]),
          ),
          Divider(color: tc.divider, height: 1),
          Expanded(
            child: _activeTab == 0
                ? const _FeedTab()
                : _activeTab == 1
                    ? const _MyPostsTab()
                    : _EmptyTab(label: 'No saved posts'),
          ),
        ],
      ),
    );
  }
}

// ── Feed Tab — streams ALL posts from Firestore ────────────────────────────

class _FeedTab extends StatelessWidget {
  const _FeedTab();
  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final tc = context.tc;
    return StreamBuilder<List<PostModel>>(
      stream: firestoreService.postsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.article_outlined, color: tc.textGrey, size: 48),
              const SizedBox(height: 12),
              Text('No posts yet. Be the first to share!', style: TextStyle(color: tc.textGrey, fontSize: 15)),
            ]),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: posts.length + 1, // +1 for official card at end
          itemBuilder: (context, i) {
            if (i < posts.length) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _FirestorePostCard(post: posts[i]),
              );
            }
            return const Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: _OfficialPostCard(),
            );
          },
        );
      },
    );
  }
}

// ── My Posts Tab — streams current user's posts ────────────────────────────

class _MyPostsTab extends StatelessWidget {
  const _MyPostsTab();
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final tc = context.tc;
    final uid = authService.currentUser?.uid;
    if (uid == null) {
      return Center(child: Text('Please log in to see your posts.', style: TextStyle(color: tc.textGrey)));
    }
    return StreamBuilder<List<PostModel>>(
      stream: firestoreService.userPostsStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.article_outlined, color: tc.textGrey, size: 48),
              const SizedBox(height: 12),
              Text('No posts yet', style: TextStyle(color: tc.textGrey, fontSize: 15)),
            ]),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: posts.length,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _FirestorePostCard(post: posts[i]),
          ),
        );
      },
    );
  }
}

// ── Firestore Post Card ────────────────────────────────────────────────────

class _FirestorePostCard extends StatefulWidget {
  final PostModel post;
  const _FirestorePostCard({required this.post});
  @override
  State<_FirestorePostCard> createState() => _FirestorePostCardState();
}

class _FirestorePostCardState extends State<_FirestorePostCard> {
  bool _liked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likesCount;
    _checkLiked();
  }

  Future<void> _checkLiked() async {
    final auth = AuthService();
    final fs = FirestoreService();
    if (auth.currentUser != null) {
      final liked = await fs.isPostLiked(widget.post.id, auth.currentUser!.uid);
      if (mounted) setState(() => _liked = liked);
    }
  }

  Future<void> _toggleLike() async {
    final auth = AuthService();
    final fs = FirestoreService();
    if (auth.currentUser == null) return;
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
    await fs.toggleLike(widget.post.id, auth.currentUser!.uid);
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final post = widget.post;
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
            child: Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primary.withValues(alpha: 0.2),
                backgroundImage: post.authorProfileImageUrl != null ? NetworkImage(post.authorProfileImageUrl!) : null,
                child: post.authorProfileImageUrl == null
                    ? Text(post.authorInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Flexible(child: Text(post.authorName, style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w700, fontSize: 14))),
                    if (post.isAvailableForWork) ...[
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
                          Text('AVAILABLE', style: TextStyle(color: secondary, fontSize: 9, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ],
                  ]),
                  Text(
                    '${_timeAgo(post.createdAt)}${post.location != null ? ' • ${post.location}' : ''}',
                    style: TextStyle(color: tc.textGrey, fontSize: 12),
                  ),
                ]),
              ),
              Icon(Icons.more_vert, color: tc.textGrey, size: 20),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(post.content, style: TextStyle(color: tc.textWhite, fontSize: 14, height: 1.5)),
          ),
          // Skills tags
          if (post.skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Wrap(spacing: 6, runSpacing: 6, children: post.skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                ),
                child: Text(s, style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w500)),
              )).toList()),
            ),
          ],
          // Post image
          if (post.imageUrl != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                post.imageUrl!,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 190,
                  color: tc.inputBackground,
                  child: Center(child: Icon(Icons.broken_image_outlined, color: tc.textGrey, size: 40)),
                ),
              ),
            ),
          ],
          // Like / comment bar
          if (post.imageUrl == null) const SizedBox(height: 10),
          Divider(color: tc.divider, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(children: [
                  Icon(_liked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined, color: _liked ? primary : tc.textGrey, size: 18),
                  const SizedBox(width: 5),
                  Text('$_likes', style: TextStyle(color: tc.textGrey, fontSize: 13)),
                ]),
              ),
              const SizedBox(width: 18),
              Icon(Icons.chat_bubble_outline_rounded, color: tc.textGrey, size: 18),
              const SizedBox(width: 5),
              Text('${post.commentsCount}', style: TextStyle(color: tc.textGrey, fontSize: 13)),
              const Spacer(),
              Icon(Icons.share_outlined, color: tc.textGrey, size: 18),
            ]),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── Empty Tab ──────────────────────────────────────────────────────────────

class _EmptyTab extends StatelessWidget {
  final String label;
  const _EmptyTab({required this.label});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.article_outlined, color: context.tc.textGrey, size: 48),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(color: context.tc.textGrey, fontSize: 15)),
      ]),
    );
  }
}

// ── Official Post Card ─────────────────────────────────────────────────────

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
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0C1F4A), Color(0xFF0A3566)]),
            ),
            child: Stack(alignment: Alignment.center, children: [
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
            ]),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified_rounded, color: primary, size: 10),
                const SizedBox(width: 3),
                Text('OFFICIAL', style: TextStyle(color: primary, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ]),
            ),
            const SizedBox(height: 6),
            Text('New Safety Certification course now available.', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 3),
            Text('Enhance your professional standing today.', style: TextStyle(color: tc.textGrey, fontSize: 12)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Text('Learn More →', style: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Tab Item ───────────────────────────────────────────────────────────────

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
        child: Column(children: [
          Text(label, style: TextStyle(
            color: active ? primary : context.tc.textGrey,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            fontSize: 15,
          )),
          const SizedBox(height: 8),
          if (active) Container(height: 2, width: label.length * 7.5, decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
        ]),
      ),
    );
  }
}
