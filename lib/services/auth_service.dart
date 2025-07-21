// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user.dart' as AppUser;
// import 'firebase_service.dart';

// class AuthService {
//   static final FirebaseAuth _auth = FirebaseService.auth;
//   static final FirebaseFirestore _firestore = FirebaseService.firestore;

//   // Register a new user
//   static Future<Map<String, dynamic>> register(AppUser.User user) async {
//     try {
//       // Create user with email and password
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: user.email,
//         password: user.password,
//       );

//       // Update display name
//       await userCredential.user?.updateDisplayName(user.fullName);

//       // Save additional user data to Firestore
//       await FirebaseService.getUserDocument(userCredential.user!.uid).set({
//         'fullName': user.fullName,
//         'username': user.username,
//         'email': user.email,
//         'phoneNumber': user.phoneNumber,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'profileImageUrl': '',
//         'bio': '',
//         'fitnessGoals': [],
//         'mentalFocus': '',
//         'totalCaloriesBurned': 0,
//         'currentStreak': 0,
//         'followingTopics': [],
//         'postsCount': 0,
//         'followersCount': 0,
//         'followingCount': 0,
//       });

//       return {
//         'success': true,
//         'message': 'Registration successful',
//         'user': userCredential.user,
//       };
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'weak-password':
//           message = 'The password provided is too weak.';
//           break;
//         case 'email-already-in-use':
//           message = 'The account already exists for that email.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is not valid.';
//           break;
//         default:
//           message = 'Registration failed: ${e.message}';
//       }
//       return {
//         'success': false,
//         'message': message,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An unexpected error occurred: $e',
//       };
//     }
//   }

//   // Login user
//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Get user data from Firestore
//       DocumentSnapshot userDoc = await FirebaseService.getUserDocument(userCredential.user!.uid).get();
      
//       if (userDoc.exists) {
//         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
//         return {
//           'success': true,
//           'message': 'Login successful',
//           'user': userCredential.user,
//           'userData': userData,
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'User data not found',
//         };
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found for that email.';
//           break;
//         case 'wrong-password':
//           message = 'Wrong password provided.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is not valid.';
//           break;
//         case 'user-disabled':
//           message = 'This user account has been disabled.';
//           break;
//         default:
//           message = 'Login failed: ${e.message}';
//       }
//       return {
//         'success': false,
//         'message': message,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An unexpected error occurred: $e',
//       };
//     }
//   }

//   // Logout user
//   static Future<void> logout() async {
//     await _auth.signOut();
//   }

//   // Get current user
//   static User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Get current user data from Firestore
//   static Future<Map<String, dynamic>?> getCurrentUserData() async {
//     User? user = getCurrentUser();
//     if (user != null) {
//       DocumentSnapshot doc = await FirebaseService.getUserDocument(user.uid).get();
//       if (doc.exists) {
//         return doc.data() as Map<String, dynamic>;
//       }
//     }
//     return null;
//   }

//   // Check if user is logged in
//   static bool isLoggedIn() {
//     return _auth.currentUser != null;
//   }

//   // Update user profile
//   static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
//     try {
//       User? user = getCurrentUser();
//       if (user != null) {
//         data['updatedAt'] = FieldValue.serverTimestamp();
//         await FirebaseService.getUserDocument(user.uid).update(data);
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Error updating user profile: $e');
//       return false;
//     }
//   }

//   // Reset password
//   static Future<Map<String, dynamic>> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       return {
//         'success': true,
//         'message': 'Password reset email sent successfully',
//       };
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found for that email.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is not valid.';
//           break;
//         default:
//           message = 'Failed to send reset email: ${e.message}';
//       }
//       return {
//         'success': false,
//         'message': message,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An unexpected error occurred: $e',
//       };
//     }
//   }

//   // Delete user account
//   static Future<Map<String, dynamic>> deleteAccount() async {
//     try {
//       User? user = getCurrentUser();
//       if (user != null) {
//         // Delete user data from Firestore
//         await FirebaseService.getUserDocument(user.uid).delete();
        
//         // Delete user account
//         await user.delete();
        
//         return {
//           'success': true,
//           'message': 'Account deleted successfully',
//         };
//       }
//       return {
//         'success': false,
//         'message': 'No user logged in',
//       };
//     } on FirebaseAuthException catch (e) {
//       return {
//         'success': false,
//         'message': 'Failed to delete account: ${e.message}',
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An unexpected error occurred: $e',
//       };
//     }
//   }
//   // Get all registered users (for debugging or community list)
// static Future<List<AppUser.User>> getAllUsers() async {
//   try {
//     QuerySnapshot snapshot = await _firestore.collection('user_profiles').get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       return AppUser.User(
//         email: data['email'] ?? '',
//         password: '', // password should not be returned
//         fullName: data['fullName'] ?? '',
//         username: data['username'] ?? '',
//         phoneNumber: data['phoneNumber'] ?? '',
//       );
//     }).toList();
//   } catch (e) {
//     print('Error fetching users: $e');
//     return [];
//   }
// }

// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as AppUser;
import 'firebase_service.dart';


class AuthService {
  static final FirebaseAuth _auth = FirebaseService.auth;
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Register a new user
  static Future<Map<String, dynamic>> register(AppUser.User user) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await userCredential.user?.updateDisplayName(user.fullName);

      await FirebaseService.getUserDocument(userCredential.user!.uid).set({
        'fullName': user.fullName,
        'username': user.username,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profileImageUrl': '',
        'bio': '',
        'fitnessGoals': [],
        'mentalFocus': '',
        'totalCaloriesBurned': 0,
        'currentStreak': 0,
        'followingTopics': [],
        'postsCount': 0,
        'followersCount': 0,
        'followingCount': 0,
        'profileCompleted': false,
      });

      return {
        'success': true,
        'message': 'Registration successful',
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'Registration failed: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await FirebaseService.getUserDocument(userCredential.user!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        return {
          'success': true,
          'message': 'Login successful',
          'user': userCredential.user,
          'userData': userData,
        };
      } else {
        return {
          'success': false,
          'message': 'User data not found',
        };
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Get all users
  static Future<List<AppUser.User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('user_profiles').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return AppUser.User(
          fullName: data['fullName'] ?? '',
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          password: '', // Do not expose or store password in Firestore
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Logout user
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current user data from Firestore
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    User? user = getCurrentUser();
    if (user != null) {
      DocumentSnapshot doc = await FirebaseService.getUserDocument(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Update user profile
  static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
  try {
    User? user = getCurrentUser();
    if (user != null) {
      data['updatedAt'] = FieldValue.serverTimestamp();

      // ✅ Step 3: Add logs for debugging
      print('🟢 [updateUserProfile] Updating user: ${user.uid}');
      final debugData = Map<String, dynamic>.from(data);
      debugData['updatedAt'] = '[FieldValue.serverTimestamp()]';
      print('📤 Data to be updated: $debugData');


      await FirebaseService.getUserDocument(user.uid).update(data);

      print('✅ [updateUserProfile] Profile updated successfully');
      return true;
    } else {
      print('❌ [updateUserProfile] No user is currently logged in.');
      return false;
    }
  } catch (e) {
    print('❌ [updateUserProfile] Error: $e');
    return false;
  }
}


  // Reset password
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent successfully',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'Failed to send reset email: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Delete user account
  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await FirebaseService.getUserDocument(user.uid).delete();
        await user.delete();

        return {
          'success': true,
          'message': 'Account deleted successfully',
        };
      }
      return {
        'success': false,
        'message': 'No user logged in',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete account: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Check if user profile is completed
  static Future<bool> isProfileCompleted() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        DocumentSnapshot doc = await FirebaseService.getUserDocument(user.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['profileCompleted'] == true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }
}
