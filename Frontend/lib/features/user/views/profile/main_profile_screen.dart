import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_jobfind/features/user/viewmodels/profile_provider.dart';
import 'package:app_jobfind/features/auth/viewmodels/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

/// Màn hình Tổng quan Hồ Sơ (Main Profile Screen)
/// Hiển thị tại tab cuối cùng của trang chủ. Dùng để xem lướt số lượng CV, 
/// việc đã ứng tuyển và theo dõi. Cung cấp nút để đi đến trang cài đặt và chỉnh hồ sơ.
class MainProfileScreen extends ConsumerStatefulWidget {
  const MainProfileScreen({super.key});

  @override
  ConsumerState<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends ConsumerState<MainProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  /// Khởi tạo và thiết kế giao diện chính ở tab Profile
  /// Gọi [fetchProfile] ngay lúc màn hình vừa nạp xong
  /// Layout cắt bằng Stack để có hộp Header Gradient đè với thông tin cá nhân.
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = ref.watch(authProvider).user;
    final userName = profileState.profile?.fullName ?? user?.fullName ?? 'User';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Stack(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF331D61), Color(0xFF14003E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.reply, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: Colors.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Text(userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U', style: const TextStyle(fontSize: 30, color: Color(0xFF14003E))),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profileState.profile?.city ?? 'Location not set',
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text('10', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(width: 4),
                                    const Text('Follower', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    const SizedBox(width: 24),
                                    const Text('20', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(width: 4),
                                    const Text('Following', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: const [
                                            Text('Edit profile', style: TextStyle(color: Colors.white, fontSize: 12)),
                                            SizedBox(width: 4),
                                            Icon(Icons.edit, color: Colors.white, size: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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

          const SizedBox(height: 24),

          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  color: const Color(0xFFFDAE5C), // Orange
                  title: 'CV đã tạo',
                  trailingIcons: [Icons.edit, Icons.add_circle_outline],
                  trailingColors: [const Color(0xFFFDAE5C), const Color(0xFFFDAE5C)],
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.work_outline,
                  color: const Color(0xFFFDAE5C),
                  title: 'Công ty đang theo dõi',
                  trailingIcons: [Icons.add_circle_outline],
                  trailingColors: [const Color(0xFFFDAE5C)],
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.work_outline,
                  color: const Color(0xFFFDAE5C),
                  title: 'Việc làm đã ứng tuyển',
                  trailingIcons: [Icons.edit],
                  trailingColors: [const Color(0xFFFDAE5C)],
                ),
                const SizedBox(height: 100), // padding for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required List<IconData> trailingIcons,
    required List<Color> trailingColors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF14003E)),
            ),
          ),
          ...List.generate(trailingIcons.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(trailingIcons[index], color: trailingColors[index], size: 20),
            );
          }),
        ],
      ),
    );
  }
}
