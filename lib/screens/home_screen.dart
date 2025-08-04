// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../widgets/animated_card.dart';
// import '../widgets/stat_card.dart';
// import '../widgets/mood_selector.dart';
// import '../widgets/progress_ring.dart';
// import '../widgets/gradient_button.dart';
// import '../services/auth_service.dart';
// import '../services/workout_service.dart';
// import '../services/food_service.dart';
// import '../services/mental_health_service.dart';
// import '../models/user.dart';
// import '../models/workout.dart';
// import '../models/food_entry.dart';
// import '../models/mental_health.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   User? currentUser;
//   bool _isLoading = true;
//   int _selectedMood = 3;
  
//   // Dashboard data
//   List<WorkoutSession> _recentWorkouts = [];
//   List<MealEntry> _todayMeals = [];
//   List<MoodEntry> _recentMoods = [];
//   Map<String, int> _todayNutrition = {};
//   Map<String, int> _weeklyStats = {};
//   double _averageMood = 0.0;
//   String _dailyTip = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeUser();
//     _loadDashboardData();
//   }

//   void _initializeUser() {
//     final firebaseUser = AuthService.getCurrentUser();
//     if (firebaseUser != null) {
//       currentUser = User(
//         fullName: firebaseUser.displayName ?? '',
//         username: firebaseUser.email?.split('@').first ?? '',
//         email: firebaseUser.email ?? '',
//         phoneNumber: firebaseUser.phoneNumber ?? '',
//         password: '',
//       );
//     }
//   }

//   Future<void> _loadDashboardData() async {
//     try {
//       // Load all dashboard data in parallel
//       final results = await Future.wait([
//         WorkoutService.getRecentWorkouts(),
//         FoodService.getMealEntriesForDate(DateTime.now()),
//         MentalHealthService.getMoodEntriesForWeek(),
//         FoodService.getTodayNutrition(),
//         _getWeeklyStats(),
//         MentalHealthService.getAverageMoodThisWeek(),
//         MentalHealthService.getDailyMindfulnessTip(),
//       ]);

//       setState(() {
//         _recentWorkouts = results[0] as List<WorkoutSession>;
//         _todayMeals = results[1] as List<MealEntry>;
//         _recentMoods = results[2] as List<MoodEntry>;
//         _todayNutrition = results[3] as Map<String, int>;
//         _weeklyStats = results[4] as Map<String, int>;
//         _averageMood = results[5] as double;
//         _dailyTip = results[6] as String;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading dashboard data: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<Map<String, int>> _getWeeklyStats() async {
//     final workouts = await WorkoutService.getTotalWorkoutsThisWeek();
//     final calories = await WorkoutService.getTotalCaloriesBurnedThisWeek();
//     final minutes = await WorkoutService.getTotalWorkoutMinutesThisWeek();
    
//     return {
//       'workouts': workouts,
//       'calories': calories,
//       'minutes': minutes,
//     };
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 AuthService.logout();
//                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         backgroundColor: AppTheme.lightGray,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: AppTheme.lightGray,
//       body: RefreshIndicator(
//         onRefresh: _loadDashboardData,
//         color: AppTheme.primaryBlue,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               // Welcome Header
//               _buildWelcomeHeader(),
//               const SizedBox(height: 32),

//               // Quick Stats Overview
//               _buildQuickStats(),
//               const SizedBox(height: 32),

//               // Mood Check-in
//               _buildMoodSection(),
//               const SizedBox(height: 32),

//               // Daily Progress
//               _buildDailyProgress(),
//               const SizedBox(height: 32),

//               // Quick Actions
//               _buildQuickActions(),
//               const SizedBox(height: 32),

//               // Daily Tip
//               _buildDailyTip(),
//               const SizedBox(height: 32),

//               // Recent Activity
//               _buildRecentActivity(),
//               const SizedBox(height: 100), // Bottom padding for navigation
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: AppTheme.primaryGradient,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: AppTheme.mediumShadow,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _getGreeting(),
//                   style: const TextStyle(
//                     color: AppTheme.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   currentUser?.fullName ?? 'User',
//                   style: const TextStyle(
//                     color: AppTheme.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Let\'s make today amazing! ✨',
//                   style: TextStyle(
//                     color: AppTheme.white.withOpacity(0.9),
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppTheme.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: IconButton(
//               onPressed: _logout,
//               icon: const Icon(Icons.settings_outlined, color: AppTheme.white, size: 24),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Today\'s Overview',
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: StatCard(
//                 title: 'Calories',
//                 value: '${_todayNutrition['calories'] ?? 0}',
//                 subtitle: 'consumed',
//                 icon: Icons.local_fire_department,
//                 iconColor: AppTheme.orange,
//                 onTap: () => DefaultTabController.of(context).animateTo(2),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: StatCard(
//                 title: 'Workouts',
//                 value: '${_weeklyStats['workouts'] ?? 0}',
//                 subtitle: 'this week',
//                 icon: Icons.fitness_center,
//                 iconColor: AppTheme.primaryGreen,
//                 onTap: () => DefaultTabController.of(context).animateTo(1),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildMoodSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Mood Check-in',
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextButton(
//               onPressed: () => DefaultTabController.of(context).animateTo(3),
//               child: const Text('View History'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         MoodSelector(
//           selectedMood: _selectedMood,
//           onMoodSelected: (mood) {
//             setState(() {
//               _selectedMood = mood;
//             });
//             // Save mood entry
//             _saveMoodEntry(mood);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDailyProgress() {
//     final caloriesGoal = 2000;
//     final caloriesConsumed = _todayNutrition['calories'] ?? 0;
//     final caloriesProgress = caloriesConsumed / caloriesGoal;
    
//     final workoutGoal = 30; // minutes
//     final workoutMinutes = _weeklyStats['minutes'] ?? 0;
//     final workoutProgress = (workoutMinutes / 7) / workoutGoal; // daily average
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Daily Progress',
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: AnimatedCard(
//                 backgroundColor: AppTheme.lightBlue,
//                 child: Column(
//                   children: [
//                     ProgressRing(
//                       progress: caloriesProgress.clamp(0.0, 1.0),
//                       color: AppTheme.orange,
//                       size: 80,
//                       strokeWidth: 6,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '${(caloriesProgress * 100).round()}%',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppTheme.textPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Calories',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       '$caloriesConsumed / $caloriesGoal',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: AnimatedCard(
//                 backgroundColor: AppTheme.lightGreen,
//                 child: Column(
//                   children: [
//                     ProgressRing(
//                       progress: workoutProgress.clamp(0.0, 1.0),
//                       color: AppTheme.primaryGreen,
//                       size: 80,
//                       strokeWidth: 6,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '${(workoutProgress * 100).round()}%',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppTheme.textPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Activity',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       '${(workoutMinutes / 7).round()} / $workoutGoal min',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: GradientButton(
//                 text: 'Start Workout',
//                 icon: Icons.fitness_center,
//                 gradient: AppTheme.orangeGradient,
//                 onPressed: () => DefaultTabController.of(context).animateTo(1),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: GradientButton(
//                 text: 'Meditate',
//                 icon: Icons.self_improvement,
//                 gradient: AppTheme.purpleGradient,
//                 onPressed: () => DefaultTabController.of(context).animateTo(3),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: GradientButton(
//                 text: 'Log Food',
//                 icon: Icons.restaurant,
//                 gradient: AppTheme.secondaryGradient,
//                 onPressed: () => DefaultTabController.of(context).animateTo(2),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: GradientButton(
//                 text: 'Community',
//                 icon: Icons.people,
//                 gradient: AppTheme.primaryGradient,
//                 onPressed: () => DefaultTabController.of(context).animateTo(4),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildDailyTip() {
//     return AnimatedCard(
//       backgroundColor: AppTheme.lightBlue,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryBlue.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.lightbulb_outline,
//                   color: AppTheme.primaryBlue,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Daily Wellness Tip',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.primaryBlue,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _dailyTip,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: AppTheme.darkBlue,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Recent Activity',
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text('View All'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         if (_recentWorkouts.isEmpty && _todayMeals.isEmpty && _recentMoods.isEmpty)
//           AnimatedCard(
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.timeline,
//                   size: 48,
//                   color: AppTheme.textSecondary.withOpacity(0.5),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No recent activity',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Start your wellness journey today!',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         else
//           Column(
//             children: [
//               ..._recentWorkouts.take(2).map((session) => _buildActivityItem(
//                 icon: Icons.fitness_center,
//                 iconColor: AppTheme.orange,
//                 title: 'Workout Session',
//                 subtitle: '${session.actualDuration} min • ${session.caloriesBurned} calories',
//                 time: _formatTime(session.startTime),
//               )),
//               ..._todayMeals.take(2).map((meal) => _buildActivityItem(
//                 icon: _getMealIcon(meal.mealType),
//                 iconColor: AppTheme.primaryGreen,
//                 title: meal.mealType,
//                 subtitle: '${meal.totalCalories} calories • ${meal.foods.length} items',
//                 time: _formatTime(meal.date),
//               )),
//               ..._recentMoods.take(1).map((mood) => _buildActivityItem(
//                 icon: Icons.mood,
//                 iconColor: _getMoodColor(mood.moodLevel),
//                 title: 'Mood Entry',
//                 subtitle: mood.moodDescription,
//                 time: _formatTime(mood.date),
//               )),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildActivityItem({
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required String subtitle,
//     required String time,
//   }) {
//     return AnimatedCard(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: iconColor, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             time,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: AppTheme.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good morning';
//     if (hour < 17) return 'Good afternoon';
//     return 'Good evening';
//   }

//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
    
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   void _saveMoodEntry(int moodLevel) async {
//     // Implementation to save mood entry
//     final moodData = {
//       1: {'emoji': '😢', 'description': 'Very Sad'},
//       2: {'emoji': '😔', 'description': 'Sad'},
//       3: {'emoji': '😐', 'description': 'Okay'},
//       4: {'emoji': '😊', 'description': 'Good'},
//       5: {'emoji': '😄', 'description': 'Great'},
//     };
    
//     // Save to database (implementation depends on your service)
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Mood saved: ${moodData[moodLevel]!['description']}'),
//         backgroundColor: AppTheme.primaryGreen,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   IconData _getMealIcon(String mealType) {
//     switch (mealType.toLowerCase()) {
//       case 'breakfast':
//         return Icons.free_breakfast;
//       case 'lunch':
//         return Icons.lunch_dining;
//       case 'dinner':
//         return Icons.dinner_dining;
//       case 'snacks':
//         return Icons.cookie;
//       default:
//         return Icons.restaurant;
//     }
//   }

//   Color _getMoodColor(int moodLevel) {
//     switch (moodLevel) {
//       case 1:
//         return Colors.red;
//       case 2:
//         return Colors.orange;
//       case 3:
//         return Colors.yellow;
//       case 4:
//         return Colors.lightGreen;
//       case 5:
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getMoodDescription(double mood) {
//     if (mood == 0) return 'Start tracking your mood';
//     if (mood <= 2) return 'Needs attention';
//     if (mood <= 3) return 'Could be better';
//     if (mood <= 4) return 'Pretty good';
//     return 'Excellent!';
//   }
// }

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_card.dart';
import '../services/auth_service.dart';
import '../services/workout_service.dart';
import '../services/food_service.dart';
import '../services/mental_health_service.dart';
import '../models/user.dart';
import '../models/workout.dart';
import '../models/food_entry.dart';
import '../models/mental_health.dart';
import 'food_log_screen.dart';
import 'mental_health_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  bool _isLoading = true;
  
  // Dashboard data
  List<WorkoutSession> _recentWorkouts = [];
  List<MealEntry> _todayMeals = [];
  List<MoodEntry> _recentMoods = [];
  Map<String, int> _todayNutrition = {};
  Map<String, int> _weeklyStats = {};
  double _averageMood = 0.0;
  String _dailyTip = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadDashboardData();
  }

  void _initializeUser() {
    final firebaseUser = AuthService.getCurrentUser();
    if (firebaseUser != null) {
      currentUser = User(
        fullName: firebaseUser.displayName ?? '',
        username: firebaseUser.email?.split('@').first ?? '',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        password: '',
      );
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      final results = await Future.wait([
        WorkoutService.getRecentWorkouts(),
        FoodService.getMealEntriesForDate(DateTime.now()),
        MentalHealthService.getMoodEntriesForWeek(),
        FoodService.getTodayNutrition(),
        _getWeeklyStats(),
        MentalHealthService.getAverageMoodThisWeek(),
        MentalHealthService.getDailyMindfulnessTip(),
      ]);

      setState(() {
        _recentWorkouts = results[0] as List<WorkoutSession>;
        _todayMeals = results[1] as List<MealEntry>;
        _recentMoods = results[2] as List<MoodEntry>;
        _todayNutrition = results[3] as Map<String, int>;
        _weeklyStats = results[4] as Map<String, int>;
        _averageMood = results[5] as double;
        _dailyTip = results[6] as String;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, int>> _getWeeklyStats() async {
    final workouts = await WorkoutService.getTotalWorkoutsThisWeek();
    final calories = await WorkoutService.getTotalCaloriesBurnedThisWeek();
    final minutes = await WorkoutService.getTotalWorkoutMinutesThisWeek();
    
    return {
      'workouts': workouts,
      'calories': calories,
      'minutes': minutes,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                _buildHeader(),
                const SizedBox(height: 30),

                // Quick stats cards
                _buildQuickStats(),
                const SizedBox(height: 30),

                // Today's progress
                _buildTodaysProgress(),
                const SizedBox(height: 30),

                // Recent activity
                _buildRecentActivity(),
                const SizedBox(height: 30),

                // Quick actions
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_getTimeOfDay()}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              currentUser?.fullName ?? 'Welcome',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            currentUser?.fullName.isNotEmpty == true 
                ? currentUser!.fullName[0].toUpperCase()
                : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Workouts',
            value: '${_weeklyStats['workouts'] ?? 0}',
            subtitle: 'This week',
            icon: Icons.fitness_center,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Calories',
            value: '${_weeklyStats['calories'] ?? 0}',
            subtitle: 'Burned',
            icon: Icons.local_fire_department,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Minutes',
            value: '${_weeklyStats['minutes'] ?? 0}',
            subtitle: 'Active',
            icon: Icons.timer,
            color: AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysProgress() {
    const caloriesGoal = 2000;
    final currentCalories = _todayNutrition['calories'] ?? 0;
    final progress = currentCalories / caloriesGoal;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressItem('Calories', '$currentCalories', 'kcal'),
              _buildProgressItem('Protein', '${_todayNutrition['protein'] ?? 0}', 'g'),
              _buildProgressItem('Carbs', '${_todayNutrition['carbs'] ?? 0}', 'g'),
              _buildProgressItem('Fat', '${_todayNutrition['fat'] ?? 0}', 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_recentWorkouts.isEmpty && _recentMoods.isEmpty)
          ModernCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.timeline,
                    size: 48,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No recent activity',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    'Start your wellness journey today!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              ..._recentWorkouts.take(3).map((workout) => 
                ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Workout Completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${workout.actualDuration} minutes • ${workout.caloriesBurned} calories',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(workout.startTime),
                        style:  TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              ..._recentMoods.take(2).map((mood) => 
                ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mood.moodEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mood: ${mood.moodDescription}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (mood.notes.isNotEmpty)
                              Text(
                                mood.notes,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(mood.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Start Workout',
                subtitle: 'Begin your fitness journey',
                icon: Icons.play_arrow,
                color: AppTheme.primaryColor,
                onTap: () => _navigateToWorkouts(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Log Food',
                subtitle: 'Track your nutrition',
                icon: Icons.restaurant,
                color: AppTheme.successColor,
                onTap: () => _navigateToFoodLog(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Mood Check',
                subtitle: 'How are you feeling?',
                icon: Icons.mood,
                color: AppTheme.accentColor,
                onTap: () => _navigateToMoodTracker(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Meditate',
                subtitle: 'Find your peace',
                icon: Icons.self_improvement,
                color: AppTheme.secondaryColor,
                onTap: () => _navigateToMeditation(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _formatTime(DateTime dateTime) {
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

  void _navigateToWorkouts() {
    // Navigate to workouts tab
    DefaultTabController.of(context).animateTo(1);
  }

  void _navigateToFoodLog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodLogScreen()),
    );
  }

  void _navigateToMoodTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
    );
  }

  void _navigateToMeditation() {
    // Navigate to meditation tab
    DefaultTabController.of(context).animateTo(2);
  }
}