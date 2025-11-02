import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPrimaryColor = kCoral;
    const Color brandAccentColor = kDeepPurple;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: brandPrimaryColor,
        title: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            'assets/logo.webp',
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.school, color: kCoral, size: 32),
          ),
        ),
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: kLogoGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // --- Welcome Header ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 80,
                      color: brandAccentColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to Excelerate!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: brandAccentColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your journey starts here!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Empowering learners through professional development programs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Action Buttons ---
              GradientButton(
                text: 'View Programs',
                onPressed: () {
                  Navigator.pushNamed(context, '/programListing');
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Edit Profile',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile editing coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // --- “Connecting” Section ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Column(
                  children: const [
                    Text(
                      'CONNECTING',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    _ConnectionCard(
                      emoji: '👩‍🎓',
                      text: 'Excellers to their future careers',
                    ),
                    SizedBox(height: 16),
                    _ConnectionCard(
                      emoji: '🏫',
                      text: 'Universities to their future Excellers',
                    ),
                    SizedBox(height: 16),
                    _ConnectionCard(
                      emoji: '💼',
                      text: 'Businesses to their future talent',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // --- Help / Footer ---
              Column(
                children: [
                  const Text(
                    'Need help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _launchURL(
                      'https://experience.4excelerate.org/supportcenter/faqsupport',
                    ),
                    child: const Text(
                      'Get Support',
                      style: TextStyle(
                        color: Color.fromARGB(255, 30, 46, 217),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Small Reusable Connection Card ---
class _ConnectionCard extends StatelessWidget {
  final String emoji;
  final String text;

  const _ConnectionCard({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
