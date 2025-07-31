import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_button.dart';
import '../models/community.dart';
import '../services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<CommunityPost> _posts = [];
  List<ForumTopic> _topics = [];
  List<CommunityChallenge> _challenges = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  final List<String> _categories = ['all', 'fitness', 'mental_health', 'nutrition', 'general'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final posts = await CommunityService.getFeedPosts(category: _selectedCategory);
      final topics = await CommunityService.getForumTopics();
      final challenges = await CommunityService.getCommunityhallenges();

      setState(() {
        _posts = posts;
        _topics = topics;
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Header
          _buildHeader(),
          
          // Tab Bar
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryBlue,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              tabs: const [
                Tab(text: 'Feed'),
                Tab(text: 'Forums'),
                Tab(text: 'Challenges'),
                Tab(text: 'Chat'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeedTab(),
                _buildForumsTab(),
                _buildChallengesTab(),
                _buildChatTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(),
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.people, color: AppTheme.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Community',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Connect, share, and grow together',
                    style: TextStyle(
                      color: AppTheme.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => _navigateToProfile(),
                icon: const Icon(Icons.account_circle, color: AppTheme.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Category Filter
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => _filterPosts(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                      ),
                      boxShadow: isSelected ? AppTheme.softShadow : null,
                    ),
                    child: Text(
                      category == 'all' ? 'All' : category.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? AppTheme.white : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Posts List
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: AppTheme.primaryBlue,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(_posts[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    post.displayName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                      post.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '@${post.username} • ${_getTimeAgo(post.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_horiz, color: AppTheme.textSecondary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(Icons.flag_outlined, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        const Text('Report'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'report') {
                    _showReportDialog(post.id, 'post');
                  }
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Post Content
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
          
          // Progress Data (if available)
          if (post.progressData != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (post.progressData!['distance'] != null)
                    _buildProgressStat('Distance', '${post.progressData!['distance']}km'),
                  if (post.progressData!['time'] != null)
                    _buildProgressStat('Time', post.progressData!['time']),
                  if (post.progressData!['calories'] != null)
                    _buildProgressStat('Calories', '${post.progressData!['calories']}'),
                ],
              ),
            ),
          ],
          
          // Tags
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags.map((tag) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '#$tag',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ).toList(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => _likePost(post.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: post.isLikedByCurrentUser 
                        ? Colors.red.withOpacity(0.1) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post.isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                        color: post.isLikedByCurrentUser ? Colors.red : AppTheme.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likesCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: post.isLikedByCurrentUser ? Colors.red : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCommentsDialog(post),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.comment_outlined, 
                        color: AppTheme.textSecondary, 
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.commentsCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: AppTheme.textSecondary, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.darkGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildForumsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _topics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(_topics[index]);
      },
    );
  }

  Widget _buildTopicCard(ForumTopic topic) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              topic.iconEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${topic.subscribersCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${topic.postsCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (topic.isSubscribed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Joined',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () => _subscribeToTopic(topic.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _challenges.length,
      itemBuilder: (context, index) {
        return _buildChallengeCard(_challenges[index]);
      },
    );
  }

  Widget _buildChallengeCard(CommunityChallenge challenge) {
    final daysLeft = challenge.endDate.difference(DateTime.now()).inDays;
    final isActive = daysLeft > 0;

    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getChallengeColor(challenge.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getChallengeIcon(challenge.type),
                  color: _getChallengeColor(challenge.type),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isActive ? '$daysLeft days left' : 'Challenge ended',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isActive ? Colors.green[600] : Colors.red[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            challenge.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${challenge.participantsCount} participants',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (challenge.prize.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 16, color: Colors.amber[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Prize available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (challenge.isParticipating)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Text(
                'You\'re participating! 🎉',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.darkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (isActive)
            GradientButton(
              text: 'Join Challenge',
              onPressed: () => _joinChallenge(challenge.id),
              gradient: LinearGradient(
                colors: [
                  _getChallengeColor(challenge.type),
                  _getChallengeColor(challenge.type).withOpacity(0.8),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.mediumGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Challenge Ended',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: AnimatedCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline, 
                  size: 64, 
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chat Feature',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect with accountability buddies\nand join group conversations',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: 'Coming Soon',
                onPressed: null,
                gradient: LinearGradient(
                  colors: [AppTheme.mediumGray, AppTheme.mediumGray],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChallengeColor(String type) {
    switch (type) {
      case 'fitness':
        return AppTheme.orange;
      case 'mental_health':
        return AppTheme.purple;
      case 'nutrition':
        return AppTheme.primaryGreen;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getChallengeIcon(String type) {
    switch (type) {
      case 'fitness':
        return Icons.fitness_center;
      case 'mental_health':
        return Icons.psychology;
      case 'nutrition':
        return Icons.restaurant;
      default:
        return Icons.emoji_events;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _filterPosts(String category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });
    _loadData();
  }

  void _likePost(String postId) async {
    await CommunityService.likePost(postId);
    _loadData();
  }

  void _subscribeToTopic(String topicId) async {
    await CommunityService.subscribeToTopic(topicId);
    _loadData();
  }

  void _joinChallenge(String challengeId) async {
    await CommunityService.joinChallenge(challengeId);
    _loadData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully joined the challenge! 🎉'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCreatePostDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    ).then((_) => _loadData());
  }

  void _showCommentsDialog(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(post: post),
    );
  }

  void _showReportDialog(String contentId, String contentType) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        contentId: contentId,
        contentType: contentType,
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityProfileScreen()),
    );
  }
}

// Placeholder screens - we'll implement these next
class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: const Center(child: Text('Create Post Screen')),
    );
  }
}

class CommentsBottomSheet extends StatelessWidget {
  final CommunityPost post;

  const CommentsBottomSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${post.commentsCount}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Text(
                'Comments feature coming soon!',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportDialog extends StatefulWidget {
  final String contentId;
  final String contentType;

  const ReportDialog({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String _selectedReason = '';
  final _descriptionController = TextEditingController();

  final List<String> _reportReasons = [
    'Spam or misleading content',
    'Harassment or bullying',
    'Inappropriate content',
    'False information',
    'Harmful or dangerous content',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Report Content'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why are you reporting this ${widget.contentType}?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: _reportReasons.map((reason) => 
              RadioListTile<String>(
                title: Text(
                  reason, 
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: reason,
                groupValue: _selectedReason,
                activeColor: AppTheme.primaryBlue,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              )
            ).toList(),
          ),
          if (_selectedReason == 'Other') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Please describe the issue',
              ),
              maxLines: 3,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        TextButton(
          onPressed: _selectedReason.isNotEmpty ? _submitReport : null,
          child: const Text(
            'Report',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _submitReport() async {
    await CommunityService.reportContent(
      contentId: widget.contentId,
      contentType: widget.contentType,
      reason: _selectedReason,
      description: _descriptionController.text,
    );
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted. Thank you for keeping our community safe.'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class CommunityProfileScreen extends StatelessWidget {
  const CommunityProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Community Profile')),
      body: const Center(child: Text('Community Profile Screen')),
    );
  }
}
