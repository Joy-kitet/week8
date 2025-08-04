// import 'package:flutter/material.dart';
// import '../models/mental_health.dart';
// import '../services/mental_health_service.dart';
// import '../widgets/custom_button.dart';
// // import '../widgets/modern_card.dart';
// import '../widgets/mood_selector.dart';
// import '../theme/app_theme.dart';

// class EnhancedMentalHealthScreen extends StatefulWidget {
//   const EnhancedMentalHealthScreen({super.key});

//   @override
//   _EnhancedMentalHealthScreenState createState() => _EnhancedMentalHealthScreenState();
// }

// class _EnhancedMentalHealthScreenState extends State<EnhancedMentalHealthScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isLoading = true;
//   String _dailyTip = '';
//   MotivationalQuote? _dailyQuote;
//   Affirmation? _dailyAffirmation;
//   double _averageMood = 0.0;
//   List<ChallengeProgress> _activeChallenges = [];
//   List<MoodEntry> _recentMoods = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadData() async {
//     try {
//       final results = await Future.wait([
//         MentalHealthService.getDailyMindfulnessTip(),
//         MentalHealthService.getDailyQuote(),
//         MentalHealthService.getDailyAffirmation(),
//         MentalHealthService.getAverageMoodThisWeek(),
//         MentalHealthService.getActiveChallenges(),
//         MentalHealthService.getMoodEntriesForWeek(),
//       ]);

//       setState(() {
//         _dailyTip = results[0] as String;
//         _dailyQuote = results[1] as MotivationalQuote?;
//         _dailyAffirmation = results[2] as Affirmation?;
//         _averageMood = results[3] as double;
//         _activeChallenges = results[4] as List<ChallengeProgress>;
//         _recentMoods = results[5] as List<MoodEntry>;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           _buildSliverAppBar(),
//         ],
//         body: Column(
//           children: [
//             _buildTabBar(),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildOverviewTab(),
//                   _buildMoodTrackingTab(),
//                   _buildMeditationTab(),
//                   _buildResourcesTab(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 200,
//       floating: false,
//       pinned: true,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF667EEA),
//                 Color(0xFF764BA2),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(AppTheme.spaceL),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(AppTheme.spaceM),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//                         ),
//                         child: const Icon(
//                           Icons.psychology,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                       ),
//                       const SizedBox(width: AppTheme.spaceM),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Mental Wellness',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Your mind matters most',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         controller: _tabController,
//         labelColor: AppTheme.primaryColor,
//         unselectedLabelColor: AppTheme.textSecondary,
//         indicatorColor: AppTheme.primaryColor,
//         indicatorWeight: 3,
//         labelStyle: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//         ),
//         tabs: const [
//           Tab(text: 'Overview'),
//           Tab(text: 'Mood'),
//           Tab(text: 'Meditate'),
//           Tab(text: 'Resources'),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(AppTheme.spaceM),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Daily Inspiration
//           _buildDailyInspiration(),
//           const SizedBox(height: AppTheme.spaceL),

//           // Quick Actions
//           _buildQuickActions(),
//           const SizedBox(height: AppTheme.spaceL),

//           // Mood Overview
//           _buildMoodOverview(),
//           const SizedBox(height: AppTheme.spaceL),

//           // Active Challenges
//           if (_activeChallenges.isNotEmpty) _buildActiveChallenges(),
//           const SizedBox(height: AppTheme.spaceL),

//           // Professional Help
//           _buildProfessionalHelp(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDailyInspiration() {
//     return Column(
//       children: [
//         // Daily Quote
//         if (_dailyQuote != null)
//           GradientCard(
//             gradient: AppTheme.primaryGradient,
//             margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.format_quote,
//                       color: Colors.white.withOpacity(0.9),
//                       size: 24,
//                     ),
//                     const SizedBox(width: AppTheme.spaceS),
//                     const Text(
//                       'Daily Inspiration',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppTheme.spaceM),
//                 Text(
//                   '"${_dailyQuote!.quote}"',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontStyle: FontStyle.italic,
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: AppTheme.spaceS),
//                 Text(
//                   '— ${_dailyQuote!.author}',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // Daily Affirmation
//         if (_dailyAffirmation != null)
//           ModernCard(
//             backgroundColor: AppTheme.accentColor.withOpacity(0.1),
//             border: Border.all(
//               color: AppTheme.accentColor.withOpacity(0.3),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.self_improvement,
//                       color: AppTheme.accentColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: AppTheme.spaceS),
//                     Text(
//                       'Daily Affirmation',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         color: AppTheme.accentColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppTheme.spaceM),
//                 Text(
//                   _dailyAffirmation!.text,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w500,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//         const SizedBox(height: AppTheme.spaceM),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: AppTheme.spaceM,
//           mainAxisSpacing: AppTheme.spaceM,
//           childAspectRatio: 1.2,
//           children: [
//             ActionCard(
//               title: 'Mood Check-in',
//               subtitle: 'How are you feeling?',
//               icon: Icons.mood,
//               color: AppTheme.successColor,
//               onTap: () => _tabController.animateTo(1),
//             ),
//             ActionCard(
//               title: 'Meditate',
//               subtitle: 'Find your peace',
//               icon: Icons.self_improvement,
//               color: AppTheme.primaryColor,
//               onTap: () => _tabController.animateTo(2),
//             ),
//             ActionCard(
//               title: 'Breathing',
//               subtitle: 'Calm your mind',
//               icon: Icons.air,
//               color: AppTheme.infoColor,
//               onTap: () => _navigateToBreathing(),
//             ),
//             ActionCard(
//               title: 'Gratitude',
//               subtitle: 'Count your blessings',
//               icon: Icons.favorite,
//               color: AppTheme.accentColor,
//               onTap: () => _navigateToGratitude(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildMoodOverview() {
//     return ModernCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'This Week\'s Mood',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               TextButton(
//                 onPressed: () => _tabController.animateTo(1),
//                 child: const Text('View Details'),
//               ),
//             ],
//           ),
//           const SizedBox(height: AppTheme.spaceM),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(AppTheme.spaceM),
//                 decoration: BoxDecoration(
//                   gradient: AppTheme.secondaryGradient,
//                   borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//                 ),
//                 child: const Icon(
//                   Icons.mood,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(width: AppTheme.spaceM),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Average Mood',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: AppTheme.spaceXS),
//                     Text(
//                       _averageMood > 0 ? '${_averageMood.toStringAsFixed(1)}/5' : 'No data yet',
//                       style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       _getMoodDescription(_averageMood),
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (_recentMoods.isNotEmpty) ...[
//             const SizedBox(height: AppTheme.spaceM),
//             const Divider(),
//             const SizedBox(height: AppTheme.spaceM),
//             Text(
//               'Recent Entries',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: AppTheme.spaceS),
//             SizedBox(
//               height: 60,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _recentMoods.take(7).length,
//                 itemBuilder: (context, index) {
//                   final mood = _recentMoods[index];
//                   return Container(
//                     margin: const EdgeInsets.only(right: AppTheme.spaceS),
//                     padding: const EdgeInsets.all(AppTheme.spaceS),
//                     decoration: BoxDecoration(
//                       color: _getMoodColor(mood.moodLevel).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
//                       border: Border.all(
//                         color: _getMoodColor(mood.moodLevel).withOpacity(0.3),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           mood.moodEmoji,
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         const SizedBox(height: AppTheme.spaceXS),
//                         Text(
//                           '${mood.date.day}/${mood.date.month}',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildActiveChallenges() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Active Challenges',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             TextButton(
//               onPressed: () => _navigateToChallenges(),
//               child: const Text('View All'),
//             ),
//           ],
//         ),
//         const SizedBox(height: AppTheme.spaceM),
//         Column(
//           children: _activeChallenges.take(2).map((progress) => 
//             ProgressCard(
//               title: 'Mental Health Challenge',
//               subtitle: 'Day ${progress.currentDay} of ${progress.completedDays.length}',
//               progress: progress.currentDay / progress.completedDays.length,
//               color: AppTheme.primaryColor,
//               icon: Icons.emoji_events,
//               onTap: () => _navigateToChallenges(),
//             ),
//           ).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildProfessionalHelp() {
//     return ModernCard(
//       backgroundColor: AppTheme.errorColor.withOpacity(0.05),
//       border: Border.all(
//         color: AppTheme.errorColor.withOpacity(0.2),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.support_agent,
//                 color: AppTheme.errorColor,
//                 size: 24,
//               ),
//               const SizedBox(width: AppTheme.spaceS),
//               Text(
//                 'Need Professional Help?',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: AppTheme.errorColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: AppTheme.spaceM),
//           Text(
//             'If you\'re experiencing persistent mental health challenges, consider reaching out to a professional.',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
//           CustomButton(
//             text: 'View Resources',
//             onPressed: () => _navigateToProfessionalHelp(),
//             backgroundColor: AppTheme.errorColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMoodTrackingTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(AppTheme.spaceM),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'How are you feeling today?',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: AppTheme.spaceL),
//           ModernCard(
//             child: MoodSelector(
//               selectedMood: 0,
//               onMoodSelected: (mood) => _saveMoodEntry(mood),
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceL),
//           _buildMoodHistory(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMoodHistory() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Mood History',
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//         const SizedBox(height: AppTheme.spaceM),
//         if (_recentMoods.isEmpty)
//           ModernCard(
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.mood,
//                     size: 48,
//                     color: AppTheme.textTertiary,
//                   ),
//                   const SizedBox(height: AppTheme.spaceM),
//                   Text(
//                     'No mood entries yet',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: AppTheme.textSecondary,
//                     ),
//                   ),
//                   const SizedBox(height: AppTheme.spaceS),
//                   Text(
//                     'Start tracking your mental wellness!',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: AppTheme.textTertiary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           Column(
//             children: _recentMoods.map((mood) => 
//               ModernCard(
//                 margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(AppTheme.spaceM),
//                       decoration: BoxDecoration(
//                         color: _getMoodColor(mood.moodLevel).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//                       ),
//                       child: Text(
//                         mood.moodEmoji,
//                         style: const TextStyle(fontSize: 24),
//                       ),
//                     ),
//                     const SizedBox(width: AppTheme.spaceM),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             mood.moodDescription,
//                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: AppTheme.spaceXS),
//                           Text(
//                             '${mood.date.day}/${mood.date.month}/${mood.date.year}',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                           if (mood.notes.isNotEmpty) ...[
//                             const SizedBox(height: AppTheme.spaceXS),
//                             Text(
//                               mood.notes,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildMeditationTab() {
//     return const MeditationScreen();
//   }

//   Widget _buildMeditationCard(String title, String duration, IconData icon, Color color, String description) {
//     return ModernCard(
//       onTap: () => _startMeditation(title),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             height: 80,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [color.withOpacity(0.8), color],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
//             ),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 32,
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
//           Text(
//             title,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceXS),
//           Text(
//             description,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: AppTheme.textSecondary,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const Spacer(),
//           Row(
//             children: [
//               Icon(
//                 Icons.timer,
//                 size: 16,
//                 color: AppTheme.textTertiary,
//               ),
//               const SizedBox(width: AppTheme.spaceXS),
//               Text(
//                 duration,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color: AppTheme.textTertiary,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.play_circle_filled,
//                 color: color,
//                 size: 24,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResourcesTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(AppTheme.spaceM),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Mental Health Resources',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: AppTheme.spaceM),
//           Text(
//             'Educational content and professional support',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: AppTheme.textSecondary,
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceL),
          
//           // Emergency Resources
//           ModernCard(
//             backgroundColor: AppTheme.errorColor.withOpacity(0.05),
//             border: Border.all(color: AppTheme.errorColor.withOpacity(0.2)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.emergency,
//                       color: AppTheme.errorColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: AppTheme.spaceS),
//                     Text(
//                       'Crisis Support',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         color: AppTheme.errorColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppTheme.spaceM),
//                 Text(
//                   'If you\'re in crisis or having thoughts of self-harm, please reach out immediately:',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: AppTheme.spaceM),
//                 _buildHelplineCard('988 Suicide & Crisis Lifeline', '988', 'Call or text 24/7'),
//                 const SizedBox(height: AppTheme.spaceS),
//                 _buildHelplineCard('Crisis Text Line', 'Text HOME to 741741', '24/7 text support'),
//               ],
//             ),
//           ),
          
//           const SizedBox(height: AppTheme.spaceL),
          
//           // Educational Resources
//           Text(
//             'Learn & Grow',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
          
//           ActionCard(
//             title: 'Understanding Anxiety',
//             subtitle: 'Learn about anxiety and coping strategies',
//             icon: Icons.psychology,
//             color: AppTheme.infoColor,
//             onTap: () => _openResource('anxiety'),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
          
//           ActionCard(
//             title: 'Depression Support',
//             subtitle: 'Resources for managing depression',
//             icon: Icons.favorite,
//             color: AppTheme.accentColor,
//             onTap: () => _openResource('depression'),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
          
//           ActionCard(
//             title: 'Stress Management',
//             subtitle: 'Techniques for handling stress',
//             icon: Icons.spa,
//             color: AppTheme.successColor,
//             onTap: () => _openResource('stress'),
//           ),
//           const SizedBox(height: AppTheme.spaceM),
          
//           ActionCard(
//             title: 'Sleep Hygiene',
//             subtitle: 'Improve your sleep quality',
//             icon: Icons.bedtime,
//             color: AppTheme.primaryColor,
//             onTap: () => _openResource('sleep'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHelplineCard(String name, String number, String description) {
//     return Container(
//       padding: const EdgeInsets.all(AppTheme.spaceM),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
//         border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.phone,
//             color: AppTheme.errorColor,
//             size: 20,
//           ),
//           const SizedBox(width: AppTheme.spaceM),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   number,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppTheme.errorColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   description,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getMoodColor(int moodLevel) {
//     switch (moodLevel) {
//       case 1:
//         return const Color(0xFFEF4444);
//       case 2:
//         return const Color(0xFFF97316);
//       case 3:
//         return const Color(0xFFF59E0B);
//       case 4:
//         return const Color(0xFF10B981);
//       case 5:
//         return const Color(0xFF059669);
//       default:
//         return AppTheme.textTertiary;
//     }
//   }

//   String _getMoodDescription(double mood) {
//     if (mood == 0) return 'Start tracking your mood';
//     if (mood <= 2) return 'Needs attention';
//     if (mood <= 3) return 'Could be better';
//     if (mood <= 4) return 'Pretty good';
//     return 'Excellent!';
//   }

//   void _saveMoodEntry(int moodLevel) async {
//     final moodData = MoodSelector.moods.firstWhere((m) => m['level'] == moodLevel);
    
//     final entry = MoodEntry(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       date: DateTime.now(),
//       moodLevel: moodLevel,
//       moodEmoji: moodData['emoji'],
//       moodDescription: moodData['label'],
//       notes: '',
//       tags: [],
//     );

//     final success = await MentalHealthService.addMoodEntry(entry);
    
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Mood entry saved! ${moodData['emoji']}'),
//           backgroundColor: AppTheme.successColor,
//         ),
//       );
//       _loadData();
//     }
//   }

//   void _startMeditation(String title) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Starting $title meditation...'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//     );
//   }

//   void _openResource(String type) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Opening $type resources...'),
//         backgroundColor: AppTheme.infoColor,
//       ),
//     );
//   }

//   void _navigateToBreathing() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Breathing exercises coming soon!'),
//         backgroundColor: AppTheme.infoColor,
//       ),
//     );
//   }

//   void _navigateToGratitude() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Gratitude journal coming soon!'),
//         backgroundColor: AppTheme.accentColor,
//       ),
//     );
//   }

//   void _navigateToChallenges() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Mental health challenges coming soon!'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//     );
//   }

//   void _navigateToProfessionalHelp() {
//     _tabController.animateTo(3);
//   }
// }