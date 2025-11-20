import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // New Settings Model
  String _name = "Taimoor Ul Islam";
  String _email = "taimoor@gmail.com";
  String _contactNumber = "0315-1234567";

  bool _alertOnCall = true;
  bool _alertOnSms = true;
  bool _alertOnEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f1e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade900.withOpacity(0.3),
                    Colors.red.shade700.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.shade400.withOpacity(0.3),
                          Colors.red.shade600.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.red.shade300,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _contactNumber,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.red.shade300),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionTitle('Alert Settings', Icons.notifications_active),

            const SizedBox(height: 12),

            _buildSettingCard(
              title: 'Alert on Call',
              subtitle: 'Send alerts when a call is detected',
              icon: Icons.call_outlined,
              iconColor: Colors.green,
              trailing: Switch(
                value: _alertOnCall,
                activeColor: Colors.green,
                onChanged: (v) => setState(() => _alertOnCall = v),
              ),
            ),

            _buildSettingCard(
              title: 'Alert on SMS',
              subtitle: 'Send alerts when SMS is received',
              icon: Icons.sms_outlined,
              iconColor: Colors.blue,
              trailing: Switch(
                value: _alertOnSms,
                activeColor: Colors.blue,
                onChanged: (v) => setState(() => _alertOnSms = v),
              ),
            ),

            _buildSettingCard(
              title: 'Alert on Email',
              subtitle: 'Send alerts when email is received',
              icon: Icons.email_outlined,
              iconColor: Colors.orange,
              trailing: Switch(
                value: _alertOnEmail,
                activeColor: Colors.orange,
                onChanged: (v) => setState(() => _alertOnEmail = v),
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // ABOUT SECTION (KEPT)
            // --------------------------------------------------
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
              iconColor: Colors.red,
              trailing: _arrow(),
            ),

            _buildSettingCard(
              title: 'Terms of Service',
              subtitle: 'View terms and conditions',
              icon: Icons.description_outlined,
              iconColor: Colors.teal,
              trailing: _arrow(),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // ACCOUNT SECTION (KEPT)
            // --------------------------------------------------
            _buildSectionTitle(
              'Account',
              Icons.account_circle_rounded,
              Colors.red,
            ),
            const SizedBox(height: 12),

            _buildSettingCard(
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              icon: Icons.delete_forever_outlined,
              iconColor: Colors.red,
              trailing: _arrow(),
              onTap: _showDeleteAccountDialog,
            ),

            const SizedBox(height: 32),

            // --------------------------------------------------
            // LOGOUT BUTTON
            // --------------------------------------------------
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

  // ----------------------------------------------------------
  // REUSABLE UI COMPONENTS
  // ----------------------------------------------------------

  Widget _arrow() => Icon(
    Icons.arrow_forward_ios_rounded,
    color: Colors.white.withOpacity(0.3),
    size: 16,
  );

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
