import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
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
            Text('Enter the 4-digit code sent to', style: TextStyle(color: tc.textGrey, fontSize: 14)),
            const SizedBox(height: 2),
            Text('+91 98765 43210', style: TextStyle(color: tc.textWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) => _OtpBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                onChanged: (v) {
                  if (v.isNotEmpty && i < 3) _focusNodes[i + 1].requestFocus();
                  if (v.isEmpty && i > 0) _focusNodes[i - 1].requestFocus();
                },
                tc: tc,
                primary: primary,
              )),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/verification-success'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
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
                  onTap: () {},
                  child: Text('Resend OTP', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
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
      width: 64, height: 64,
      decoration: BoxDecoration(
        color: tc.inputBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tc.borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(color: tc.textWhite, fontSize: 24, fontWeight: FontWeight.w700),
        decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
        onChanged: onChanged,
      ),
    );
  }
}
