// import 'package:clothes_shop/Home/login_screen.dart';
// import 'package:clothes_shop/Home/look_good_screen.dart';
// import 'package:clothes_shop/controller/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   bool rememberMe = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   final LoginController controller = Get.put(LoginController());

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔙 Back Button
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LookGoodScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                   color: Colors.black87,
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all(
//                       Colors.grey.shade100,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🏷 Title
//                 const Center(
//                   child: Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // 👤 Username Field
//                 const Text(
//                   "Username",
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 5),
//                 TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.check, color: Colors.green),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.purple),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // 📧 Email Field
//                 const Text(
//                   "Email Address",
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 5),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.check, color: Colors.green),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.purple),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // 🔐 Password Field
//                 const Text(
//                   "Password",
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 5),
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.purple),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // 🔐 Confirm Password Field
//                 const Text(
//                   "Confirm Password",
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 5),
//                 TextFormField(
//                   controller: confirmPasswordController,
//                   obscureText: !_isConfirmPasswordVisible,
//                   decoration: InputDecoration(
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.purple),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔘 Remember me switch
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Remember me",
//                       style: TextStyle(fontSize: 15, color: Colors.black87),
//                     ),
//                     Switch(
//                       value: rememberMe,
//                       onChanged: (value) {
//                         setState(() {
//                           rememberMe = value;
//                         });
//                       },
//                       activeColor: Colors.white,
//                       activeTrackColor: Colors.purple,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 40),

//                 //i have account already
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "I have an account already.",
//                       style: TextStyle(
//                         color: Colors.purple,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // 🟣 Sign Up Button
//                 SizedBox(
//                   width: double.maxFinite,
//                   height: 55,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       final name = nameController.text.trim();
//                       final email = emailController.text.trim();
//                       final password = passwordController.text.trim();
//                       final confirmPassword = confirmPasswordController.text
//                           .trim();

//                       if (name.isEmpty ||
//                           email.isEmpty ||
//                           password.isEmpty ||
//                           confirmPassword.isEmpty) {
//                         Get.snackbar('Error', 'Please fill in all fields');
//                         return;
//                       }

//                       if (password != confirmPassword) {
//                         Get.snackbar('Error', 'Passwords do not match');
//                         return;
//                       }

//                     //   controller.register(
//                     //     name,
//                     //     email,
//                     //     password,
//                     //     confirmPassword,
//                     //   );
//                     // },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
