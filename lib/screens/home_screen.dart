import 'package:fake_true_news/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'about_screen.dart';
import 'history_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _newsController = TextEditingController();
  bool _isLoading = false;
  final List<Map<String, String>> _searchHistory = [];
  final FocusNode _focusNode = FocusNode();

  final Color _primaryColor = const Color(0xFF4361EE);
  final Color _secondaryColor = const Color(0xFF3A0CA3);
  final Color _accentColor = const Color(0xFF4CC9F0);
  final Color _textColor = const Color(0xFFF8F9FA);
  final Color _darkTextColor = const Color(0xFF212529);
  final Color _cardColor = const Color(0xFF2B2D42);

  Future<void> _checkNews() async {
    final String newsText = _newsController.text.trim();
    if (newsText.isEmpty) {
      _showSnackBar("Please enter some news text!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/predict/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": newsText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String prediction = data["prediction"];

        setState(() {
          _searchHistory.insert(0, {
            "text": newsText,
            "prediction": prediction,
            "time": DateTime.now().toString(),
          });
        });

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ResultScreen(prediction: prediction),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutQuart,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      } else {
        throw Exception("Server responded with status: \${response.statusCode}");
      }
    } catch (e) {
      _showSnackBar("Error: \${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: _cardColor,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWideScreen = size.width > 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'TRUTH VERIFIER',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: isWideScreen ? 26 : 22,
            letterSpacing: 1.2,
            color: _textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_secondaryColor, _primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWideScreen ? 700 : 500),
              child: Column(
                children: [
                  SizedBox(height: 13,),
                  Image.asset(
                    'assets/images/img2.png',
                    height: 150,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Verify News Authenticity',
                    style: GoogleFonts.poppins(
                      fontSize: isWideScreen ? 30 : 24,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Detect misinformation with AI',
                    style: GoogleFonts.poppins(
                      fontSize: isWideScreen ? 16 : 14,
                      color: _textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(),
                  const SizedBox(height: 25),
                  _buildAnalyzeButton(isWideScreen),
                  const SizedBox(height: 40),
                  _buildFeatureCards(isWideScreen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _newsController,
        focusNode: _focusNode,
        maxLines: 5,
        style: GoogleFonts.poppins(fontSize: 16, color: _textColor),
        decoration: InputDecoration(
          hintText: 'Paste news article or claim here...',
          hintStyle: GoogleFonts.poppins(color: _textColor.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: _newsController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: _textColor.withOpacity(0.6)),
            onPressed: () {
              _newsController.clear();
              setState(() {});
            },
          )
              : null,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildAnalyzeButton(bool isWideScreen) {
    return SizedBox(
      width: isWideScreen ? 280 : double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(Icons.verified, color: _darkTextColor),
        label: _isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        )
            : Text(
          'ANALYZE CONTENT',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: _darkTextColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _checkNews,
      ),
    );
  }

  Widget _buildFeatureCards(bool isWideScreen) {
    final children = [
      _buildInfoCard(
        icon: Icons.article,
        title: "News Database",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsScreen()),
        ),
      ),
      const SizedBox(height: 20, width: 20),
      _buildInfoCard(
        icon: Icons.article,
        title: "Recently Check",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen(history: _searchHistory)),
        ),
      ),
      const SizedBox(height: 20, width: 20),
      _buildInfoCard(
        icon: Icons.info_outline,
        title: "How It Works",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        ),
      ),
    ];

    return isWideScreen
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: children)
        : Column(children: children);
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _cardColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _accentColor.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: _accentColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}