import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_button.dart';
import '../models/mental_health.dart';
import '../services/mental_health_service.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  _MentalHealthScreenState createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  bool _isLoading = true;
  String _dailyTip = '';
  MotivationalQuote? _dailyQuote;
  Affirmation? _dailyAffirmation;
  double _averageMood = 0.0;
  List<ChallengeProgress> _activeChallenges = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final tip = await MentalHealthService.getDailyMindfulnessTip();
      final quote = await MentalHealthService.getDailyQuote();
      final affirmation = await MentalHealthService.getDailyAffirmation();
      final avgMood = await MentalHealthService.getAverageMoodThisWeek();
      final challenges = await MentalHealthService.getActiveChallenges();

      setState(() {
        _dailyTip = tip;
        _dailyQuote = quote;
        _dailyAffirmation = affirmation;
        _averageMood = avgMood;
        _activeChallenges = challenges;
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.lightGray,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header
            _buildHeader(),
            const SizedBox(height: 32),

            // Mental Health Overview
            _buildMentalHealthOverview(),
            const SizedBox(height: 32),

            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 32),

            // Daily Quote & Affirmation
            _buildDailyContent(),
            const SizedBox(height: 32),

            // Active Challenges
            if (_activeChallenges.isNotEmpty) _buildActiveChallenges(),
            const SizedBox(height: 32),

            // Professional Help
            _buildProfessionalHelp(),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.purpleGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: AppTheme.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mental Wellness',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nurture your inner peace',
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
            child: const Icon(
              Icons.spa,
              color: AppTheme.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentalHealthOverview() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mood,
                  color: AppTheme.purple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week\'s Mood',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      _averageMood > 0 ? '${_averageMood.toStringAsFixed(1)}/5' : 'No data yet',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getMoodDescription(_averageMood),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppTheme.primaryBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Mindfulness Tip',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dailyTip,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wellness Activities',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              'Mood Check-in',
              Icons.mood,
              AppTheme.primaryGreen,
              () => _navigateToMoodTracker(),
            ),
            _buildActionCard(
              'Meditate',
              Icons.self_improvement,
              AppTheme.purple,
              () => _navigateToMeditations(),
            ),
            _buildActionCard(
              'Breathing',
              Icons.air,
              AppTheme.primaryBlue,
              () => _navigateToBreathing(),
            ),
            _buildActionCard(
              'Gratitude',
              Icons.favorite,
              AppTheme.pink,
              () => _navigateToGratitude(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return AnimatedCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyContent() {
    return Column(
      children: [
        // Daily Quote
        if (_dailyQuote != null)
          AnimatedCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.format_quote, color: AppTheme.orange),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Quote',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '"${_dailyQuote!.quote}"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '- ${_dailyQuote!.author}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

        // Daily Affirmation
        if (_dailyAffirmation != null)
          AnimatedCard(
            backgroundColor: AppTheme.lightGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.self_improvement, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Affirmation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _dailyAffirmation!.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkGreen,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActiveChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Challenges',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToChallenges(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: _activeChallenges.take(2).map((progress) => 
            AnimatedCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '🏆',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Challenge in Progress',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Day ${progress.currentDay} of ${progress.completedDays.length}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircularProgressIndicator(
                    value: progress.currentDay / progress.completedDays.length,
                    backgroundColor: AppTheme.mediumGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.purple),
                  ),
                ],
              ),
            )
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildProfessionalHelp() {
    return AnimatedCard(
      backgroundColor: Colors.red[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.support_agent, color: Colors.red[600], size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Need Professional Help?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'If you\'re experiencing persistent mental health challenges, consider reaching out to a professional.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'View Resources',
            onPressed: () => _navigateToProfessionalHelp(),
            gradient: LinearGradient(
              colors: [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodDescription(double mood) {
    if (mood == 0) return '';
    if (mood <= 2) return 'Needs attention';
    if (mood <= 3) return 'Could be better';
    if (mood <= 4) return 'Pretty good';
    return 'Excellent!';
  }

  void _navigateToMoodTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
    );
  }

  void _navigateToMeditations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MeditationsScreen()),
    );
  }

  void _navigateToBreathing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BreathingExercisesScreen()),
    );
  }

  void _navigateToGratitude() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GratitudeJournalScreen()),
    );
  }

  void _navigateToMoodHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodHistoryScreen()),
    );
  }

  void _navigateToChallenges() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChallengesScreen()),
    );
  }

  void _navigateToProfessionalHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfessionalHelpScreen()),
    );
  }
}

// Placeholder screens - we'll implement these next
class MoodTrackerScreen extends StatelessWidget {
  const MoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: const Center(child: Text('Mood Tracker Screen')),
    );
  }
}

class MeditationsScreen extends StatelessWidget {
  const MeditationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Meditations')),
      body: const Center(child: Text('Meditations Screen')),
    );
  }
}

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Breathing Exercises')),
      body: const Center(child: Text('Breathing Exercises Screen')),
    );
  }
}

class GratitudeJournalScreen extends StatelessWidget {
  const GratitudeJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Gratitude Journal')),
      body: const Center(child: Text('Gratitude Journal Screen')),
    );
  }
}

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Mood History')),
      body: const Center(child: Text('Mood History Screen')),
    );
  }
}

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Mental Health Challenges')),
      body: const Center(child: Text('Challenges Screen')),
    );
  }
}

class ProfessionalHelpScreen extends StatelessWidget {
  const ProfessionalHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(title: const Text('Professional Help')),
      body: const Center(child: Text('Professional Help Screen')),
    );
  }
}