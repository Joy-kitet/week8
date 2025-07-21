import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout.dart';
import 'firebase_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class WorkoutService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final FirebaseAuth _auth = FirebaseService.auth;

  // Get available workouts (these can be predefined or from admin)
  static Future<List<Workout>> getWorkouts() async {
    try {
      // For now, return predefined workouts. In production, these could be stored in Firestore
      return _getPredefinedWorkouts();
    } catch (e) {
      print('Error getting workouts: $e');
      return _getPredefinedWorkouts();
    }
  }

  static List<Workout> _getPredefinedWorkouts() {
    return [
      Workout(
        id: '1',
        title: 'Morning Cardio Blast',
        description: 'High-intensity cardio workout to kickstart your day',
        durationMinutes: 20,
        category: 'Cardio',
        difficulty: 'Beginner',
        videoUrl: 'https://youtu.be/FeR-4_Opt-g',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['None'],
        calories: 200,
      ),
      Workout(
        id: '2',
        title: 'Full Body Strength',
        description: 'Complete strength training for all muscle groups',
        durationMinutes: 45,
        category: 'Strength',
        difficulty: 'Intermediate',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Dumbbells', 'Resistance Bands'],
        calories: 350,
      ),
      Workout(
        id: '3',
        title: 'Yoga Flow',
        description: 'Relaxing yoga sequence for flexibility and mindfulness',
        durationMinutes: 30,
        category: 'Yoga',
        difficulty: 'Beginner',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Yoga Mat'],
        calories: 150,
      ),
      Workout(
        id: '4',
        title: 'HIIT Power Session',
        description: 'Intense interval training for maximum calorie burn',
        durationMinutes: 25,
        category: 'HIIT',
        difficulty: 'Advanced',
        videoUrl: 'https://youtu.be/FeR-4_Opt-g',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['None'],
        calories: 300,
      ),
      Workout(
        id: '5',
        title: 'Core Crusher',
        description: 'Targeted core workout for a strong midsection',
        durationMinutes: 15,
        category: 'Core',
        difficulty: 'Intermediate',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Exercise Mat'],
        calories: 120,
      ),
    ];
  }

  static Future<List<Workout>> getWorkoutsByCategory(String category) async {
    final allWorkouts = await getWorkouts();
    if (category == 'All') return allWorkouts;
    return allWorkouts.where((workout) => workout.category == category).toList();
  }

  // Save workout session to Firebase
  static Future<bool> startWorkoutSession(WorkoutSession session) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserWorkouts(currentUser.uid).add({
        'workoutId': session.workoutId,
        'startTime': Timestamp.fromDate(session.startTime),
        'endTime': session.endTime != null ? Timestamp.fromDate(session.endTime!) : null,
        'actualDuration': session.actualDuration,
        'caloriesBurned': session.caloriesBurned,
        'notes': session.notes,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error saving workout session: $e');
      return false;
    }
  }

  // Get user's workout sessions from Firebase
  static Future<List<WorkoutSession>> getWorkoutSessions() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserWorkouts(currentUser.uid)
          .orderBy('startTime', descending: true)
          .get();

      List<WorkoutSession> sessions = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        sessions.add(WorkoutSession(
          id: doc.id,
          workoutId: data['workoutId'],
          startTime: (data['startTime'] as Timestamp).toDate(),
          endTime: data['endTime'] != null ? (data['endTime'] as Timestamp).toDate() : null,
          actualDuration: data['actualDuration'],
          caloriesBurned: data['caloriesBurned'],
          notes: data['notes'] ?? '',
        ));
      }

      return sessions;
    } catch (e) {
      print('Error getting workout sessions: $e');
      return [];
    }
  }

  static Future<List<WorkoutSession>> getRecentWorkouts() async {
    final sessions = await getWorkoutSessions();
    return sessions.take(5).toList();
  }

  static Future<int> getTotalWorkoutsThisWeek() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      
      QuerySnapshot snapshot = await FirebaseService.getUserWorkouts(currentUser.uid)
          .where('startTime', isGreaterThan: Timestamp.fromDate(weekAgo))
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting total workouts this week: $e');
      return 0;
    }
  }

  static Future<int> getTotalCaloriesBurnedThisWeek() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      
      QuerySnapshot snapshot = await FirebaseService.getUserWorkouts(currentUser.uid)
          .where('startTime', isGreaterThan: Timestamp.fromDate(weekAgo))
          .get();

      int totalCalories = 0;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalCalories += (data['caloriesBurned'] as int? ?? 0);
      }

      return totalCalories;
    } catch (e) {
      print('Error getting total calories burned this week: $e');
      return 0;
    }
  }

  static Future<int> getTotalWorkoutMinutesThisWeek() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      
      QuerySnapshot snapshot = await FirebaseService.getUserWorkouts(currentUser.uid)
          .where('startTime', isGreaterThan: Timestamp.fromDate(weekAgo))
          .get();

      int totalMinutes = 0;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalMinutes += (data['actualDuration'] as int? ?? 0);
      }

      return totalMinutes;
    } catch (e) {
      print('Error getting total workout minutes this week: $e');
      return 0;
    }
  }

  // Legacy method for compatibility
  Future<void> addWorkoutEntry({
    required String uid,
    required String type,
    required int duration,
    required DateTime date,
    String? notes,
  }) async {
    try {
      await FirebaseService.getUserWorkouts(uid).add({
        'type': type,
        'duration': duration,
        'date': Timestamp.fromDate(date),
        'notes': notes ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding workout entry: $e');
      rethrow;
    }
  }
}



