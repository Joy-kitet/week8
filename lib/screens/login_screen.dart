

// import 'package:flutter/material.dart';
// import 'package:wellness/screens/main_screen.dart';
// import 'package:wellness/screens/profile_setup_screen.dart';
// import '../services/auth_service.dart';
// import '../utils/validators.dart';
 
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_button.dart';

// // // class LoginScreen extends StatefulWidget {
// // //   const LoginScreen({super.key});

// // //   @override
// // //   _LoginScreenState createState() => _LoginScreenState();
// // // }

// // // class _LoginScreenState extends State<LoginScreen> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final _emailController = TextEditingController();
// // //   final _passwordController = TextEditingController();
// // //   bool _isLoading = false;

// // //   @override
// // //   void dispose() {
// // //     _emailController.dispose();
// // //     _passwordController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _login() async {
// // //     if (!_formKey.currentState!.validate()) {
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     try {
// // //       final result = await AuthService.login(
// // //         _emailController.text.trim(),
// // //         _passwordController.text,
// // //       );

// // //       if (result['success']) {
// // //         // Navigate to home screen
// // //         Navigator.pushReplacementNamed(context, '/main');
        
// // //         // Show success message
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(result['message']),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       } else {
// // //         // Show error message
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(result['message']),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('An error occurred. Please try again.'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     } finally {
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }

// // //   Future<void> _resetPassword() async {
// // //     if (_emailController.text.trim().isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('Please enter your email address first'),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     final result = await AuthService.resetPassword(_emailController.text.trim());
    
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text(result['message']),
// // //         backgroundColor: result['success'] ? Colors.green : Colors.red,
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.all(24.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const SizedBox(height: 60),
              
// // //               // Header
// // //               Center(
// // //                 child: Column(
// // //                   children: [
// // //                     Icon(
// // //                       Icons.lock_outline,
// // //                       size: 80,
// // //                       color: Theme.of(context).primaryColor,
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     Text(
// // //                       'Welcome Back',
// // //                       style: TextStyle(
// // //                         fontSize: 28,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.grey[800],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     Text(
// // //                       'Sign in to your account',
// // //                       style: TextStyle(
// // //                         fontSize: 16,
// // //                         color: Colors.grey[600],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
              
// // //               const SizedBox(height: 48),
              
// // //               // Login Form
// // //               Form(
// // //                 key: _formKey,
// // //                 child: Column(
// // //                   children: [
// // //                     CustomTextField(
// // //                       label: 'Email',
// // //                       hint: 'Enter your email address',
// // //                       controller: _emailController,
// // //                       validator: Validators.validateEmail,
// // //                       keyboardType: TextInputType.emailAddress,
// // //                       prefixIcon: Icons.email_outlined,
// // //                     ),
                    
// // //                     const SizedBox(height: 20),
                    
// // //                     CustomTextField(
// // //                       label: 'Password',
// // //                       hint: 'Enter your password',
// // //                       controller: _passwordController,
// // //                       isPassword: true,
// // //                       validator: Validators.validatePassword,
// // //                       prefixIcon: Icons.lock_outline,
// // //                     ),
                    
// // //                     const SizedBox(height: 12),
                    
// // //                     // Forgot Password
// // //                     Align(
// // //                       alignment: Alignment.centerRight,
// // //                       child: TextButton(
// // //                         onPressed: _resetPassword,
// // //                         child: Text(
// // //                           'Forgot Password?',
// // //                           style: TextStyle(
// // //                             color: Theme.of(context).primaryColor,
// // //                             fontWeight: FontWeight.w500,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
                    
// // //                     const SizedBox(height: 32),
                    
// // //                     // Login Button
// // //                     CustomButton(
// // //                       text: 'Sign In',
// // //                       onPressed: _login,
// // //                       isLoading: _isLoading,
// // //                     ),
                    
// // //                     const SizedBox(height: 24),
                    
// // //                     // Divider
// // //                     Row(
// // //                       children: [
// // //                         const Expanded(child: Divider()),
// // //                         Padding(
// // //                           padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                           child: Text(
// // //                             'OR',
// // //                             style: TextStyle(
// // //                               color: Colors.grey[600],
// // //                               fontWeight: FontWeight.w500,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         const Expanded(child: Divider()),
// // //                       ],
// // //                     ),
                    
// // //                     const SizedBox(height: 24),
                    
// // //                     // Sign Up Button
// // //                     CustomButton(
// // //                       text: 'Create New Account',
// // //                       onPressed: () {
// // //                         Navigator.pushNamed(context, '/signup');
// // //                       },
// // //                       backgroundColor: Colors.grey[100],
// // //                       textColor: Theme.of(context).primaryColor,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import '../services/auth_service.dart';
// // import '../utils/validators.dart';
// // import '../widgets/custom_button.dart';
// // import '../widgets/custom_text_field.dart';
// // import 'signup_screen.dart';
// // import 'main_screen.dart';
// // import 'profile_setup_screen.dart';

// // class LoginScreen extends StatefulWidget {
// //   @override
// //   _LoginScreenState createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final bool obscureText;
  
// //   bool _isLoading = false;
// //   bool _obscurePassword = true;
// //   String _errorMessage = '';

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _login() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //       _errorMessage = '';
// //     });

// //     try {
// //       final result = await AuthService.login(
// //         _emailController.text.trim(),
// //         _passwordController.text,
// //       );

// //       if (result['success']) {
// //         // Check if profile is completed
// //         bool profileCompleted = await AuthService.isProfileCompleted();
        
// //         if (profileCompleted) {
// //           Navigator.of(context).pushReplacement(
// //             MaterialPageRoute(builder: (context) => MainScreen()),
// //           );
// //         } else {
// //           Navigator.of(context).pushReplacement(
// //             MaterialPageRoute(builder: (context) => ProfileSetupScreen()),
// //           );
// //         }
// //       } else {
// //         setState(() {
// //           _errorMessage = result['message'];
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _errorMessage = 'An unexpected error occurred. Please try again.';
// //       });
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.all(24.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 SizedBox(height: 60),
                
// //                 // Logo or App Name
// //                 Icon(
// //                   Icons.fitness_center,
// //                   size: 80,
// //                   color: Colors.blue,
// //                 ),
                
// //                 SizedBox(height: 20),
                
// //                 Text(
// //                   'Welcome Back!',
// //                   style: TextStyle(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black87,
// //                   ),
// //                   textAlign: TextAlign.center,
// //                 ),
                
// //                 SizedBox(height: 8),
                
// //                 Text(
// //                   'Sign in to continue your fitness journey',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     color: Colors.grey[600],
// //                   ),
// //                   textAlign: TextAlign.center,
// //                 ),
                
// //                 SizedBox(height: 40),

// //                 // Email field
                
// //                 CustomTextField(
// //                   controller: _emailController,
// //                   label: 'Email',
// //                   hint: 'Enter your email',
// //                   prefixIcon: Icons.email,
// //                   keyboardType: TextInputType.emailAddress,
// //                   validator: Validators.validateEmail,
// //                 ),
                
// //                 SizedBox(height: 20),
// //                 CustomTextField(
// //                   controller: _passwordController,
// //                   label: 'Password',
// //                   hint: 'Enter your password',
// //                   prefixIcon: Icons.lock,
// //                   obscureText: _obscurePassword,
// //                   suffixIcon: IconButton(
// //                     icon: Icon(
// //                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
// //                     ),
// //                     onPressed: () {
// //                       setState(() {
// //                         _obscurePassword = !_obscurePassword;
// //                       });
// //                     },
// //                   ),
// //                   validator: Validators.validatePassword,
// //                 ),
                
// //                 SizedBox(height: 30),

// //                 // Error message
// //                 if (_errorMessage.isNotEmpty)
// //                   Container(
// //                     padding: EdgeInsets.all(12),
// //                     margin: EdgeInsets.only(bottom: 20),
// //                     decoration: BoxDecoration(
// //                       color: Colors.red[50],
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.red[200]!),
// //                     ),
// //                     child: Text(
// //                       _errorMessage,
// //                       style: TextStyle(color: Colors.red[700]),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),

// //                 // Login button
// //                 CustomButton(
// //                   text: _isLoading ? 'Signing In...' : 'Sign In',
// //                   onPressed: _isLoading ? null : _login,
// //                   isLoading: _isLoading,
// //                 ),
                
// //                 SizedBox(height: 20),

// //                 // Forgot password
// //                 TextButton(
// //                   onPressed: () {
// //                     // TODO: Implement forgot password
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Forgot password feature coming soon!')),
// //                     );
// //                   },
// //                   child: Text(
// //                     'Forgot Password?',
// //                     style: TextStyle(
// //                       color: Colors.blue,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                 ),
                
// //                 SizedBox(height: 40),

// //                 // Sign up link
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Don\'t have an account? ',
// //                       style: TextStyle(
// //                         color: Colors.grey[600],
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => SignupScreen()),
// //                         );
// //                       },
// //                       child: Text(
// //                         'Sign Up',
// //                         style: TextStyle(
// //                           color: Colors.blue,
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
  
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   String _errorMessage = '';
//   final bool _obscureText = false; // declare obscureText here

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final result = await AuthService.login(
//         _emailController.text.trim(),
//         _passwordController.text,
//       );

//       if (result['success']) {
//         // Check if profile is completed
//         bool profileCompleted = await AuthService.isProfileCompleted();
        
//         if (profileCompleted) {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()),
//           );
//         } else {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => ProfileSetupScreen()),
//           );
//         }
//       } else {
//         setState(() {
//           _errorMessage = result['message'];
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//     Future<void> _resetPassword() async {
//   if (_emailController.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please enter your email address first'),
//         backgroundColor: Colors.orange,
//       ),
//     );
//     return;
//   }

//   final result = await AuthService.resetPassword(_emailController.text.trim());

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(result['message']),
//       backgroundColor: result['success'] ? Colors.green : Colors.red,
//     ),
//   );
// }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 60),
                
//                 // Header
//                 Center(
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.lock_outline,
//                         size: 80,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Welcome Back',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Sign in to your account',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 48),
                
//                 // Login Form
//                 Column(
//                   children: [
//                     CustomTextField(
//                       label: 'Email',
//                       hint: 'Enter your email address',
//                       controller: _emailController,
//                       validator: Validators.validateEmail,
//                       keyboardType: TextInputType.emailAddress,
//                       prefixIcon: Icons.email_outlined,
//                     ),
                    
//                     const SizedBox(height: 20),
                    
//                     CustomTextField(
//                       label: 'Password',
//                       hint: 'Enter your password',
//                       controller: _passwordController,
//                       isPassword: true,
//                       validator: Validators.validatePassword,
//                       prefixIcon: Icons.lock_outline,
//                     ),
                    
//                     const SizedBox(height: 12),
                    
//                     // Forgot Password
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: _resetPassword,
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 32),
                    
//                     // Login Button
//                     CustomButton(
//                       text: 'Sign In',
//                       onPressed: _login,
//                       isLoading: _isLoading,
//                     ),
                    
//                     const SizedBox(height: 24),
                    
//                     // Divider
//                     Row(
//                       children: [
//                         const Expanded(child: Divider()),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             'OR',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         const Expanded(child: Divider()),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 24),
                    
//                     // Sign Up Button
//                     CustomButton(
//                       text: 'Create New Account',
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/signup');
//                       },
//                       backgroundColor: Colors.grey[100],
//                       textColor: Theme.of(context).primaryColor,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wellness/screens/main_screen.dart';
import 'package:wellness/screens/profile_setup_screen.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final bool _obscurePassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (result['success']) {
        bool profileCompleted = await AuthService.isProfileCompleted();

        if (profileCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await AuthService.resetPassword(_emailController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  isPassword: true,
                  validator: Validators.validatePassword,
                  prefixIcon: Icons.lock_outline,
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                CustomButton(
                  text: _isLoading ? 'Signing In...' : 'Sign In',
                  onPressed: _isLoading ? null : _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                CustomButton(
                  text: 'Create New Account',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  backgroundColor: Colors.grey[100],
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
