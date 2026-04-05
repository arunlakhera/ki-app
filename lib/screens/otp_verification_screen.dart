import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme_colors.dart';
import '../services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _authService = AuthService();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  bool _resending = false;

  Map<String, dynamic> get _args =>
      (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};

  String get _verificationId => _args['verificationId'] ?? '';
  String get _phone => _args['phone'] ?? '';
  bool get _isSignup => _args['isSignup'] ?? false;

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _otp;
    if (otp.length < 6) {
      _showError('Please enter the complete 6-digit OTP.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _authService.verifyOTP(verificationId: _verificationId, otp: otp);

      if (_isSignup) {
        // Create user profile in Firestore after phone verification
        await _authService.createUserProfile(
          name: _args['name'] ?? '',
          phone: _phone,
          userType: _args['userType'] ?? 'worker',
          location: _args['city'],
          skills: [_args['skill'] ?? 'Electrician'],
        );
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/verification-success', (r) => false);
        }
      } else {
        // Login flow — check if profile exists
        final exists = await _authService.userProfileExists();
        if (mounted) {
          if (exists) {
            Navigator.pushNamedAndRemoveUntil(context, '/worker-home', (r) => false);
          } else {
            // No profile yet, send to signup
            Navigator.pushNamedAndRemoveUntil(context, '/user-type', (r) => false);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _showError(_otpErrorMessage(e.code));
    } catch (e) {
      _showError('Verification failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _resending = true);
    _authService.verifyPhone(
      phoneNumber: _phone,
      resendToken: _args['resendToken'] as int?,
      onCodeSent: (verificationId, resendToken) {
        if (mounted) {
          setState(() => _resending = false);
          // Update args with new verification ID
          _args['verificationId'] = verificationId;
          _args['resendToken'] = resendToken;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('OTP resent successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      onAutoVerified: (_) {},
      onFailed: (e) {
        if (mounted) {
          setState(() => _resending = false);
          _showError('Failed to resend OTP.');
        }
      },
      onAutoRetrievalTimeout: (_) {},
    );
  }

  String _otpErrorMessage(String code) {
    switch (code) {
      case 'invalid-verification-code': return 'Invalid OTP. Please check and try again.';
      case 'session-expired': return 'OTP expired. Please request a new one.';
      default: return 'Verification failed. Please try again.';
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
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.message_outlined, color: primary, size: 28),
            ),
            const SizedBox(height: 20),
            Text('OTP Verification', style: TextStyle(color: tc.textWhite, fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Enter the 6-digit code sent to', style: TextStyle(color: tc.textGrey, fontSize: 14)),
            const SizedBox(height: 2),
            Text(_phone, style: TextStyle(color: tc.textWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => _OtpBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) _focusNodes[i + 1].requestFocus();
                  if (v.isEmpty && i > 0) _focusNodes[i - 1].requestFocus();
                  // Auto-verify when all 6 digits entered
                  if (_otp.length == 6) _verifyOtp();
                },
                tc: tc,
                primary: primary,
              )),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
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
                          Text('VERIFY OTP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive the code? ", style: TextStyle(color: tc.textGrey, fontSize: 13)),
                GestureDetector(
                  onTap: _resending ? null : _resendOtp,
                  child: Text(
                    _resending ? 'Sending...' : 'Resend OTP',
                    style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
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

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final AppThemeColors tc;
  final Color primary;
  const _OtpBox({required this.controller, required this.focusNode, required this.onChanged, required this.tc, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 56,
      decoration: BoxDecoration(
        color: tc.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(color: tc.textWhite, fontSize: 22, fontWeight: FontWeight.w700),
        decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
        onChanged: onChanged,
      ),
    );
  }
}
