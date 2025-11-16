import 'package:clothes_shop/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'look_good_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool _isPasswordVisible = false;

  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 👇 Prevent keyboard overflow
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          // <-- FIXED SCROLL
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LookGoodScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.black87,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.grey.shade100,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🏷 Title
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please enter your data to continue",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Email
              const Text(
                "Email",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 5),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.check, color: Colors.green),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Password
              const Text(
                "Password",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 5),

              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Strong",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
              ),

              // Forgot Password
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text(
              //       "Forgot password?",
              //       style: TextStyle(
              //         color: Colors.redAccent,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),

              // Remember Me
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Remember me",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Switch(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() => rememberMe = value);
                    },
                    activeTrackColor: Colors.purple,
                    activeColor: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Terms
              const Text.rich(
                TextSpan(
                  text:
                      "By connecting your account confirm that you agree\nwith our ",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                  children: [
                    TextSpan(
                      text: "Term and Condition",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
