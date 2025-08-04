// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../theme/app_theme.dart';
// import 'home_screen.dart';
// import 'workout_screen.dart';
// import 'food_log_screen.dart';
// import 'mental_health_screen.dart';
// import 'community_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late TabController _tabController;
//   late AnimationController _fabAnimationController;
//   late Animation<double> _fabAnimation;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const WorkoutScreen(),
//     const FoodLogScreen(),
//     const MentalHealthScreen(),
//     const CommunityScreen(),
//   ];

//   final List<Map<String, dynamic>> _navItems = [
//     {'icon': Icons.dashboard_outlined, 'activeIcon': Icons.dashboard, 'label': 'Home'},
//     {'icon': Icons.fitness_center_outlined, 'activeIcon': Icons.fitness_center, 'label': 'Workouts'},
//     {'icon': Icons.restaurant_outlined, 'activeIcon': Icons.restaurant, 'label': 'Nutrition'},
//     {'icon': Icons.psychology_outlined, 'activeIcon': Icons.psychology, 'label': 'Wellness'},
//     {'icon': Icons.people_outline, 'activeIcon': Icons.people, 'label': 'Community'},
//   ];
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
//     );
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         setState(() {
//           _selectedIndex = _tabController.index;
//         });
//         _fabAnimationController.reset();
//         _fabAnimationController.forward();
//       }
//     });
//     _fabAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _fabAnimationController.dispose();
//     super.dispose();
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _tabController.animateTo(index);
    
//     // Haptic feedback
//     HapticFeedback.lightImpact();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.lightGray,
//       body: SafeArea(
//         child: TabBarView(
//           controller: _tabController,
//           children: _screens,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: AppTheme.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(_navItems.length, (index) {
//                 final item = _navItems[index];
//                 final isSelected = _selectedIndex == index;
                
//                 return GestureDetector(
//                   onTap: () => _onItemTapped(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: isSelected 
//                           ? AppTheme.primaryBlue.withOpacity(0.1) 
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 200),
//                           child: Icon(
//                             isSelected ? item['activeIcon'] : item['icon'],
//                             key: ValueKey(isSelected),
//                             color: isSelected 
//                                 ? AppTheme.primaryBlue 
//                                 : AppTheme.textSecondary,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         AnimatedDefaultTextStyle(
//                           duration: const Duration(milliseconds: 200),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                             color: isSelected 
//                                 ? AppTheme.primaryBlue 
//                                 : AppTheme.textSecondary,
//                           ),
//                           child: Text(item['label']),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: ScaleTransition(
//         scale: _fabAnimation,
//         child: FloatingActionButton(
//           onPressed: _showQuickAddDialog,
//           backgroundColor: AppTheme.primaryBlue,
//           foregroundColor: AppTheme.white,
//           elevation: 8,
//           child: const Icon(Icons.add, size: 28),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   void _showQuickAddDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         decoration: const BoxDecoration(
//           color: AppTheme.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: AppTheme.mediumGray,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Quick Add',
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildQuickAddButton(
//                     'Log Meal',
//                     Icons.restaurant,
//                     AppTheme.primaryGreen,
//                     () {
//                       Navigator.pop(context);
//                       _tabController.animateTo(2);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildQuickAddButton(
//                     'Start Workout',
//                     Icons.fitness_center,
//                     AppTheme.orange,
//                     () {
//                       Navigator.pop(context);
//                       _tabController.animateTo(1);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildQuickAddButton(
//                     'Mood Check',
//                     Icons.mood,
//                     AppTheme.purple,
//                     () {
//                       Navigator.pop(context);
//                       _tabController.animateTo(3);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildQuickAddButton(
//                     'Meditate',
//                     Icons.self_improvement,
//                     AppTheme.primaryBlue,
//                     () {
//                       Navigator.pop(context);
//                       _tabController.animateTo(3);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickAddButton(String label, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'workout_screen.dart';
import 'community_screen.dart';
import 'meditation_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkoutScreen(),
    const MeditationScreen(),
    const CommunityScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1D29),
        elevation: 8,
        selectedItemColor: Colors.blue[400],
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Meditation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
