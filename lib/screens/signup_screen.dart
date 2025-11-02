import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _coral = Color(0xFFEF6E55);
const Color _warmPink = Color(0xFFEF6D57);
const Color _magentaTransition = Color(0xFFEA5E7E);
const Color _purpleTransition = Color(0xFFE34B9E);
const Color _deepPurple = Color(0xFFDC47BA);

const List<Color> _logoGradientColors = [
  _coral,
  _warmPink,
  _magentaTransition,
  _purpleTransition,
  _deepPurple,
];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildTextFormField({
    required String label,
    bool obscure = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Widget? helper,
  }) {
    final bool isPassword = label.toLowerCase().contains('password');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontFamily: 'Poppins'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: _coral, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      label.contains('Confirm')
                          ? (_obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility)
                          : (_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                    ),
                    onPressed: () {
                      setState(() {
                        if (label.contains('Confirm')) {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        } else {
                          _obscurePassword = !_obscurePassword;
                        }
                      });
                    },
                  )
                : null,
          ),
          validator: validator,
        ),
        if (helper != null) ...[const SizedBox(height: 6), helper],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final contentWidth = width > 600 ? 420.0 : double.infinity;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: _logoGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Card(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Image.asset('assets/logo.webp', height: 80),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join Excelerate and start your journey today.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Form Fields ---
                        _buildTextFormField(
                          label: 'First Name *',
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter first name'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          label: 'Last Name *',
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter last name'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          label: 'Email *',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your email';
                            }
                            if (!RegExp(
                              r'^[\w\.-]+@[\w\.-]+\.\w+$',
                            ).hasMatch(val)) {
                              return 'Invalid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(label: 'Country of Nationality'),
                        const SizedBox(height: 12),

                        // --- Password Validation with Helper Text ---
                        _buildTextFormField(
                          label: 'Password *',
                          obscure: _obscurePassword,
                          controller: _passwordController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter password';
                            }
                            if (val.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            if (!RegExp(r'[A-Za-z]').hasMatch(val)) {
                              return 'Password must contain at least one letter';
                            }
                            if (!RegExp(r'\d').hasMatch(val)) {
                              return 'Password must contain at least one number';
                            }
                            return null;
                          },
                          helper: const Text(
                            'Must include at least 8 characters, 1 letter, and 1 number.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          label: 'Confirm Password *',
                          obscure: _obscureConfirmPassword,
                          controller: _confirmPasswordController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (val != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // --- Terms Checkbox ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeToTerms,
                              onChanged: (val) =>
                                  setState(() => agreeToTerms = val ?? false),
                              activeColor: _coral,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to '),
                                    TextSpan(
                                      text: 'Terms of Use',
                                      style: const TextStyle(
                                        color: _coral,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchUrl(
                                          'https://experience.4excelerate.org/legal/terms',
                                        ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                        color: _coral,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchUrl(
                                          'https://experience.4excelerate.org/legal/privacy',
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- Buttons ---
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: agreeToTerms
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/home',
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _coral,
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: _coral),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: _coral,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // --- Divider with OR ---
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.black26)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.black26)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- Sign In Link ---
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(
                                    color: _coral,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // --- Footer Help Section ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Having issues?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () => _launchUrl(
                'https://experience.4excelerate.org/supportcenter/faqsupport',
              ),
              child: const Text(
                'Get Help',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
