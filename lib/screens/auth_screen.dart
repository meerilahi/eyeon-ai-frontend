import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLogin = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    final authController = context.read<AuthController>();
    try {
      if (_isLogin) {
        await authController.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await authController.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please log in.'),
            ),
          );
          setState(() {
            _isLogin = true;
            _errorMessage = null;
            _confirmPasswordController.clear();
          });
        }
      }
      if (mounted) {
        setState(() => _errorMessage = null);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---------- TOP CURVED BLUE BACKGROUND ----------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopCurveClipper(),
              child: Container(height: 200, color: Colors.red),
            ),
          ),

          // ---------- BOTTOM CURVED BLUE BACKGROUND ----------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BottomCurveClipper(),
              child: Container(height: 150, color: Colors.red),
            ),
          ),

          // -------------- CONTENT -----------------
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // ---------- LOGO ----------
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.remove_red_eye,
                    size: 45,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  "EyeOn AI",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),

                const SizedBox(height: 40),

                // ---------- TEXT FIELDS ----------
                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 18),

                CustomTextField(
                  controller: _passwordController,
                  label: "Password",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: 18),

                if (!_isLogin)
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),

                const SizedBox(height: 18),

                // ---------- ERROR MESSAGE ----------
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 25),

                // ---------- LOGIN / SIGNUP BUTTON ----------
                CustomButton(
                  text: _isLogin ? "Login →" : "Sign Up",
                  onPressed: _authenticate,
                  isLoading: authController.isLoading,
                ),

                const SizedBox(height: 18),

                // ---------- SWITCH AUTH MODE ----------
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: RichText(
                    text: TextSpan(
                      text: _isLogin
                          ? "Don't have an account? "
                          : "Already have an account? ",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: _isLogin ? "Sign up" : "Log in",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------- CUSTOM CLIPPERS FOR CURVES ---------

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(0, size.height * 0.75);
    p.quadraticBezierTo(
      size.width * 0.40,
      size.height,
      size.width,
      size.height * 0.65,
    );
    p.lineTo(size.width, 0);
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.moveTo(0, size.height * 0.30);
    p.quadraticBezierTo(size.width * 0.60, 0, size.width, size.height * 0.30);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
