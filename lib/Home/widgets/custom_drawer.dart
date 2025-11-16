import 'package:clothes_shop/Home/login_screen.dart';
import 'package:clothes_shop/helper/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkMode = false;
  final box = GetStorage();
  late int userId;

  @override
  Widget build(BuildContext context) {
    userId = box.read("user_id") ?? 0;
    final user = box.read('user');
    final bool isLoggedIn = user != null; // 🔥 check login

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================
              // USER PROFILE HEADER
              // ====================
              Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        (isLoggedIn &&
                            user['avatar'] != null &&
                            user['avatar'] != "")
                        ? NetworkImage(user['avatar'])
                        : null, // no image, use icon instead
                    child:
                        (isLoggedIn &&
                            user['avatar'] != null &&
                            user['avatar'] != "")
                        ? null // has image → no icon
                        : const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoggedIn ? user['name'] : "Guest User",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoggedIn ? user['email'] : "Please sign in",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isLoggedIn)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${user['orders'] ?? 0} Orders",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 30),

              // ====================
              // DARK MODE
              // ====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _drawerItem(Icons.dark_mode_outlined, "Dark Mode"),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() => isDarkMode = value);
                    },
                    activeTrackColor: Colors.purple,
                    activeColor: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Divider(color: Colors.grey.shade300, thickness: 0.6),

              const SizedBox(height: 10),

              // ====================
              // MENU LIST
              // ====================
              _drawerItem(Icons.info_outline, "Account Information"),
              _drawerItem(Icons.lock_outline, "Password"),
              _drawerItem(Icons.shopping_bag_outlined, "Order"),
              _drawerItem(Icons.credit_card_outlined, "My Cards"),
              _drawerItem(Icons.favorite_border, "Wishlist"),
              _drawerItem(Icons.settings_outlined, "Settings"),

              const Spacer(),

              // ====================
              // LOGIN OR LOGOUT
              // ====================
              if (!isLoggedIn)
                // ====================
                // SIGN IN BUTTON
                // ====================
                InkWell(
                  onTap: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.login, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // ====================
                // LOGOUT BUTTON
                // ====================
                InkWell(
                  onTap: () async {
                    final api = ApiService();
                    await api.logout();

                    await box.erase(); // remove token & user

                    Get.snackbar(
                      "Success",
                      "Logged out successfully",
                      backgroundColor: Colors.purple,
                      colorText: Colors.white,
                    );

                    Get.offAll(() => const LoginScreen());
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================
  // Drawer Item Widget
  // ====================
  Widget _drawerItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        final bool isLoggedIn = box.read("user") != null;

        // Restrict to logged-in users
        if (!isLoggedIn && title != "Settings" && title != "Dark Mode") {
          Get.snackbar(
            "Login Required",
            "Please sign in first",
            backgroundColor: Colors.purple,
            colorText: Colors.white,
          );
          return;
        }

        switch (title) {
          case "Account Information":
            Get.toNamed("/account-info"); // create route
            break;

          case "Password":
            Get.toNamed("/change-password");
            break;

          case "Order":
            Get.toNamed("/orders");
            break;

          case "My Cards":
            Get.toNamed("/cards");
            break;

          case "Wishlist":
            Get.toNamed("/favorite");
            break;

          case "Settings":
            Get.toNamed("/settings");
            break;

          default:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 22),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
