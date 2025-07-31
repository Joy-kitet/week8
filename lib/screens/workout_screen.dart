import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_button.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Workout> _workouts = [];
  List<Workout> _filteredWorkouts = [];
  List<WorkoutSession> _recentSessions = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Cardio', 'Strength', 'Yoga', 'HIIT', 'Core'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final workouts = await WorkoutService.getWorkouts();
      final recentSessions = await WorkoutService.getRecentWorkouts();
      
      setState(() {
        _workouts = workouts;
        _filteredWorkouts = workouts;
        _recentSessions = recentSessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterWorkouts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredWorkouts = _workouts;
      } else {
        _filteredWorkouts = _workouts.where((workout) => workout.category == category).toList();
      }
    });
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

            // Stats Cards
            _buildStatsCards(),
            const SizedBox(height: 32),

            // Category Filter
            _buildCategoryFilter(),
            const SizedBox(height: 24),

            // Workouts Grid
            _buildWorkoutsGrid(),
            const SizedBox(height: 32),

            // Recent Sessions
            if (_recentSessions.isNotEmpty) _buildRecentSessions(),
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
        gradient: AppTheme.orangeGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: AppTheme.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fitness Training',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Transform your body and mind',
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
              Icons.trending_up,
              color: AppTheme.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
  final thisWeekWorkouts = WorkoutService.getTotalWorkoutsThisWeek();
  final thisWeekCaloriesBurned = WorkoutService.getTotalCaloriesBurnedThisWeek();
  final thisWeekWorkoutMinutes = WorkoutService.getTotalWorkoutMinutesThisWeek();

  return Row(
    children: [
      // 🏋️‍♀️ Workouts
      Expanded(
        child: FutureBuilder<int>(
          future: thisWeekWorkouts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return _buildStatCard(
                'This Week',
                '${snapshot.data}',
                'workouts',
                Icons.fitness_center,
                Colors.blue,
              );
            }
          },
        ),
      ),

      const SizedBox(width: 12),

      // 🔥 Calories
      Expanded(
        child: FutureBuilder<int>(
          future: thisWeekCaloriesBurned,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return _buildStatCard(
                'Calories',
                '${snapshot.data}',
                'burned',
                Icons.local_fire_department,
                Colors.red,
              );
            }
          },
        ),
      ),

      const SizedBox(width: 12),

      // ⏱️ Minutes
      Expanded(
        child: FutureBuilder<int>(
          future: thisWeekWorkoutMinutes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return _buildStatCard(
                'Minutes',
                '${snapshot.data}',
                'active',
                Icons.timer,
                Colors.green,
              );
            }
          },
        ),
      ),
    ],
  );
}


  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Categories',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => _filterWorkouts(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                      ),
                      boxShadow: isSelected ? AppTheme.softShadow : null,
                    ),
                    child: Text(
                      category,
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
      ],
    );
  }

  Widget _buildWorkoutsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Workouts',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredWorkouts.length,
          itemBuilder: (context, index) {
            return _buildWorkoutCard(_filteredWorkouts[index]);
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    Color difficultyColor;
    switch (workout.difficulty) {
      case 'Beginner':
        difficultyColor = AppTheme.primaryGreen;
        break;
      case 'Intermediate':
        difficultyColor = AppTheme.orange;
        break;
      case 'Advanced':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = AppTheme.textSecondary;
    }

    return AnimatedCard(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      onTap: () => _startWorkout(workout),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with gradient overlay
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.orangeGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 48,
                    color: AppTheme.white,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: difficultyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      workout.difficulty,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    workout.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${workout.durationMinutes}min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Icon(Icons.local_fire_department, size: 16, color: AppTheme.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${workout.calories}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Workouts',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _recentSessions.map((session) => 
            AnimatedCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fitness_center, color: AppTheme.orange),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout Session',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${session.actualDuration} min • ${session.caloriesBurned} calories',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '${session.startTime.day}/${session.startTime.month}/${session.startTime.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ).toList(),
        ),
      ],
    );
  }

  void _startWorkout(Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlayerScreen(workout: workout),
      ),
    );
  }
}

class WorkoutPlayerScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutPlayerScreen({super.key, required this.workout});

  @override
  _WorkoutPlayerScreenState createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.workout.durationMinutes * 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: Text(widget.workout.title),
        backgroundColor: AppTheme.orange,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            
            // Video Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.orangeGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.mediumShadow,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 80,
                  color: AppTheme.white,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            Text(
              widget.workout.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              widget.workout.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Progress
            Text(
              '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')} / ${(_totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(_totalSeconds % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 20),
            
            LinearProgressIndicator(
              value: _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0,
              backgroundColor: AppTheme.mediumGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.orange),
              borderRadius: BorderRadius.circular(8),
              minHeight: 8,
            ),
            
            const SizedBox(height: 40),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentSeconds = 0;
                    });
                  },
                  icon: const Icon(Icons.replay, size: 32),
                  color: AppTheme.textSecondary,
                ),
                
                const SizedBox(width: 20),
                
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.orangeGradient,
                    boxShadow: AppTheme.mediumShadow,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      
                      if (_isPlaying) {
                        _startTimer();
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: AppTheme.white,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                IconButton(
                  onPressed: () {
                    _completeWorkout();
                  },
                  icon: const Icon(Icons.stop, size: 32),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    if (_isPlaying && _currentSeconds < _totalSeconds) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlaying && mounted) {
          setState(() {
            _currentSeconds++;
          });
          
          if (_currentSeconds < _totalSeconds) {
            _startTimer();
          } else {
            _completeWorkout();
          }
        }
      });
    }
  }

  void _completeWorkout() {
    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutId: widget.workout.id,
      startTime: DateTime.now().subtract(Duration(seconds: _currentSeconds)),
      endTime: DateTime.now(),
      actualDuration: _currentSeconds ~/ 60,
      caloriesBurned: (widget.workout.calories * (_currentSeconds / _totalSeconds)).round(),
      notes: '',
    );
    
    WorkoutService.startWorkoutSession(session);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Workout Complete!'),
        content: Text('Great job! You burned ${session.caloriesBurned} calories in ${session.actualDuration} minutes.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Done',
              style: TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}