import 'package:flutter/material.dart';
import '../theme/gradients.dart';
import '../widgets/gradient_button.dart';
import '../services/api_service.dart';

class ProgramListingScreen extends StatefulWidget {
  const ProgramListingScreen({super.key});

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> programs = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchProgramData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  Future<void> fetchProgramData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await apiService.fetchPrograms();

      // ✅ Add mock demo programs if less than 8
      final List<dynamic> updatedPrograms = List.from(data);

      if (updatedPrograms.length < 8) {
        updatedPrograms.addAll([
          {
            'title': 'Leadership Essentials',
            'description':
                'Enhance your ability to lead teams effectively and drive performance.',
          },
          {
            'title': 'Digital Marketing Mastery',
            'description':
                'Understand SEO, social media marketing, and data analytics in modern marketing.',
          },
          {
            'title': 'Business Communication Skills',
            'description':
                'Improve your professional communication, presentation, and writing skills.',
          },
          {
            'title': 'Data Analytics for Beginners',
            'description':
                'Learn how to analyze data and make informed business decisions using simple tools.',
          },
          {
            'title': 'AI & Machine Learning Foundations',
            'description':
                'Get introduced to AI concepts, models, and real-world applications of machine learning.',
          },
          {
            'title': 'Project Management Professional',
            'description':
                'Master the fundamentals of managing projects efficiently with Agile and Scrum frameworks.',
          },
        ]);
      }

      setState(() {
        programs = updatedPrograms;
        isLoading = false;
        _controller.forward();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load programs. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Programs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kBrandGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // 🧭 BODY SECTION
      body: RefreshIndicator(
        onRefresh: fetchProgramData,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  key: const ValueKey('error'),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                )
              : programs.isEmpty
              ? const Center(
                  key: ValueKey('empty'),
                  child: Text(
                    'No programs available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  key: const ValueKey('programList'),
                  padding: const EdgeInsets.all(16),
                  itemCount: programs.length,
                  itemBuilder: (context, index) {
                    final program = programs[index];
                    final animation =
                        Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              index * 0.1,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                    return SlideTransition(
                      position: animation,
                      child: FadeTransition(
                        opacity: _controller,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6F61), Color(0xFF6C63FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.deepPurple.shade50,
                                  radius: 28,
                                  child: const Icon(
                                    Icons.school_rounded,
                                    color: Colors.deepPurple,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        program['title'] ?? 'Untitled Program',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        program['description'] ??
                                            'No description available.',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GradientButton(
                                        text: 'View',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/programDetails',
                                            arguments: program,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
