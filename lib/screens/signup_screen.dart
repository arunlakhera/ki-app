import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
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
        title: Text('Create Account', style: TextStyle(color: tc.textWhite, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Join KI Platform', style: TextStyle(color: tc.textWhite, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Fill in your details to get started', style: TextStyle(color: tc.textGrey, fontSize: 13)),
            const SizedBox(height: 28),
            _label('FULL NAME', primary),
            const SizedBox(height: 8),
            _inputField(controller: _nameController, hint: 'Enter your full name', tc: tc, icon: Icons.person_outline),
            const SizedBox(height: 20),
            _label('MOBILE NUMBER', primary),
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
                    style: TextStyle(color: tc.textWhite, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number',
                      hintStyle: TextStyle(color: tc.textGrey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            _label('CITY / DISTRICT', primary),
            const SizedBox(height: 8),
            _inputField(controller: _cityController, hint: 'e.g. Mumbai, Pune, Delhi', tc: tc, icon: Icons.location_city_outlined),
            const SizedBox(height: 20),
            _label('PRIMARY SKILL', primary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: tc.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tc.borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: 'Electrician',
                  isExpanded: true,
                  dropdownColor: tc.cardBackground,
                  style: TextStyle(color: tc.textWhite, fontSize: 15),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: tc.textGrey),
                  items: ['Electrician', 'Plumber', 'Carpenter', 'Welder', 'Painter', 'Mason']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreed,
                  activeColor: primary,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: tc.textGrey, fontSize: 13),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(text: 'Terms of Service', style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                          const TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreed ? () => Navigator.pushNamed(context, '/otp-verification') : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: primary.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('SEND OTP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ', style: TextStyle(color: tc.textGrey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text('Log In', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, Color primary) =>
      Text(text, style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2));

  Widget _inputField({required TextEditingController controller, required String hint, required AppThemeColors tc, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: tc.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.borderColor),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: tc.textWhite, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: tc.textGrey),
          prefixIcon: Icon(icon, color: tc.textGrey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        ),
      ),
    );
  }
}
