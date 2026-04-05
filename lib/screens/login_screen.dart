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
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _phoneController.dispose(); super.dispose(); }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      _showError('Please enter a valid 10-digit mobile number.');
      return;
    }
    setState(() => _loading = true);
    final fullPhone = '+91$phone';
    _authService.verifyPhone(
      phoneNumber: fullPhone,
      onCodeSent: (verificationId, resendToken) {
        if (mounted) setState(() => _loading = false);
        Navigator.pushNamed(context, '/otp-verification', arguments: {
          'verificationId': verificationId,
          'resendToken': resendToken,
          'phone': fullPhone,
          'isSignup': false,
        });
      },
      onAutoVerified: (credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            final exists = await _authService.userProfileExists();
            if (mounted) {
              if (exists) {
                Navigator.pushNamedAndRemoveUntil(context, '/worker-home', (r) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, '/user-type', (r) => false);
              }
            }
          }
        } catch (_) {
          if (mounted) setState(() => _loading = false);
        }
      },
      onFailed: (e) {
        if (mounted) {
          setState(() => _loading = false);
          _showError(_phoneErrorMessage(e.code));
        }
      },
      onAutoRetrievalTimeout: (_) {},
    );
  }

  String _phoneErrorMessage(String code) {
    switch (code) {
      case 'invalid-phone-number': return 'Invalid phone number format.';
      case 'too-many-requests': return 'Too many attempts. Try again later.';
      case 'quota-exceeded': return 'SMS quota exceeded. Try again later.';
      default: return 'Could not send OTP. Please try again.';
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
            Text('MOBILE NUMBER', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: tc.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tc.borderColor),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: tc.borderColor))),
                  child: Text('+91', style: TextStyle(color: tc.textWhite, fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(color: tc.textWhite, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile number',
                      hintStyle: TextStyle(color: tc.textGrey),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: primary.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('SEND OTP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
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
