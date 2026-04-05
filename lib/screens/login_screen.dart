import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme_colors.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password.');
      return;
    }
    setState(() => _loading = true);
    try {
      await _authService.signInWithEmail(email: email, password: password);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/worker-home', (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      _showError(_authErrorMessage(e.code));
    } catch (e) {
      _showError('Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'invalid-email': return 'Invalid email address.';
      case 'user-disabled': return 'This account has been disabled.';
      case 'too-many-requests': return 'Too many attempts. Please try later.';
      case 'invalid-credential': return 'Invalid email or password.';
      default: return 'Login failed. Please try again.';
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFFE02424),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Enter your email first, then tap Forgot Password.');
      return;
    }
    try {
      await _authService.sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Password reset email sent. Check your inbox.'),
          backgroundColor: context.tc.cardBackground,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (_) {
      _showError('Could not send reset email. Check your email address.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tc.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Welcome Back', style: TextStyle(color: tc.textWhite, fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Log in to your KI account', style: TextStyle(color: tc.textGrey, fontSize: 14)),
            const SizedBox(height: 32),
            Text('EMAIL ADDRESS', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: tc.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tc.borderColor),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: tc.textWhite, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: tc.textGrey),
                  prefixIcon: Icon(Icons.email_outlined, color: tc.textGrey, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('PASSWORD', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: tc.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tc.borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: tc.textWhite, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: tc.textGrey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: tc.textGrey),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _forgotPassword,
                child: Text('Forgot Password?', style: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: primary.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('LOG IN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: TextStyle(color: tc.textGrey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/user-type'),
                  child: Text('Sign Up', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
