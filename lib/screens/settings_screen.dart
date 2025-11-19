import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _soundEnabled = true;
  bool _autoRecording = true;
  double _sensitivity = 0.7;
  String _quality = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f1e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade900.withOpacity(0.3),
                    Colors.blue.shade700.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.blue.shade400.withOpacity(0.3),
                          Colors.blue.shade600.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.blue.shade300,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.blue.shade300,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // General Section
            _buildSectionTitle('General', Icons.settings_rounded),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Notifications',
              subtitle: 'Receive alerts and updates',
              icon: Icons.notifications_outlined,
              iconColor: Colors.orange,
              trailing: Switch(
                value: _notificationsEnabled,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
            ),
            _buildSettingCard(
              title: 'Dark Mode',
              subtitle: 'Enable dark theme',
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.purple,
              trailing: Switch(
                value: _darkModeEnabled,
                activeColor: Colors.purple,
                onChanged: (value) {
                  setState(() => _darkModeEnabled = value);
                },
              ),
            ),
            _buildSettingCard(
              title: 'Sound',
              subtitle: 'Enable sound effects',
              icon: Icons.volume_up_outlined,
              iconColor: Colors.blue,
              trailing: Switch(
                value: _soundEnabled,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Camera Settings
            _buildSectionTitle('Camera Settings', Icons.videocam_rounded),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Auto Recording',
              subtitle: 'Automatically record on motion',
              icon: Icons.fiber_manual_record_rounded,
              iconColor: Colors.red,
              trailing: Switch(
                value: _autoRecording,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() => _autoRecording = value);
                },
              ),
            ),
            _buildSettingCard(
              title: 'Video Quality',
              subtitle: _quality,
              icon: Icons.high_quality_rounded,
              iconColor: Colors.green,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () => _showQualityPicker(),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.teal,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Motion Sensitivity',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_sensitivity * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.teal.shade300,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.teal,
                      inactiveTrackColor: Colors.teal.withOpacity(0.2),
                      thumbColor: Colors.teal,
                      overlayColor: Colors.teal.withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _sensitivity,
                      onChanged: (value) {
                        setState(() => _sensitivity = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security Section
            _buildSectionTitle('Security', Icons.security_rounded),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Change Password',
              subtitle: 'Update your password',
              icon: Icons.lock_outline_rounded,
              iconColor: Colors.orange,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security',
              icon: Icons.verified_user_outlined,
              iconColor: Colors.green,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About', Icons.info_outline_rounded),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'App Version',
              subtitle: '1.0.0',
              icon: Icons.app_settings_alt_rounded,
              iconColor: Colors.blue,
            ),
            _buildSettingCard(
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.purple,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              title: 'Terms of Service',
              subtitle: 'View terms and conditions',
              icon: Icons.description_outlined,
              iconColor: Colors.teal,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Danger Zone
            _buildSectionTitle(
              'Danger Zone',
              Icons.warning_amber_rounded,
              Colors.red,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              icon: Icons.cleaning_services_outlined,
              iconColor: Colors.orange,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              icon: Icons.delete_forever_outlined,
              iconColor: Colors.red,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              onTap: () => _showDeleteAccountDialog(),
            ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, [Color? color]) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.white.withOpacity(0.7), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQualityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Video Quality',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...['Low', 'Medium', 'High', 'Ultra'].map((quality) {
              return ListTile(
                leading: Icon(
                  Icons.high_quality_rounded,
                  color: _quality == quality
                      ? Colors.green
                      : Colors.white.withOpacity(0.5),
                ),
                title: Text(
                  quality,
                  style: TextStyle(
                    color: _quality == quality ? Colors.green : Colors.white,
                    fontWeight: _quality == quality
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: _quality == quality
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => _quality = quality);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
            const SizedBox(width: 12),
            const Text('Delete Account', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
