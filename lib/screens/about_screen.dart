import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  // New color scheme
  final Color _primaryColor = const Color(0xFF4361EE); // Vibrant blue
  final Color _secondaryColor = const Color(0xFF3A0CA3); // Deep purple
  final Color _accentColor = const Color(0xFF4CC9F0); // Light blue
  final Color _textColor = const Color(0xFFF8F9FA); // White
  final Color _textSecondaryColor = const Color(0xFFADB5BD); // Light gray
  final Color _cardColor = const Color(0xFF2B2D42).withOpacity(0.8); // Dark blue-gray

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'About Truth Verifier',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: _textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_secondaryColor, _primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  const SizedBox(height: 80),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _accentColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 80,
                  color: _accentColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Truth Verifier',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'AI-powered app to detect fake news and verify the truth.',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: _textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Developed by Pratik Khemnar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: _textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _sectionTitle('How It Works'),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.maxWidth > 600
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildSteps(),
                  )
                      : Column(children: _buildSteps());
                },
              ),
              const SizedBox(height: 40),
              _sectionTitle('Why Use This App?'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'In todays digital world, misinformation spreads faster than ever. Truth Verifier empowers you to detect and stop fake news using cutting-edge AI, helping you stay informed and make smarter decisions.',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: _textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Divider(color: _textColor.withOpacity(0.2)),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
    ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
  }

  List<Widget> _buildSteps() {
    return [
      _buildStep(
        icon: Icons.content_paste_rounded,
        title: 'Paste News Text',
        description: 'Copy and paste any news headline or article into the app to start verification.',
        iconColor: _accentColor,
      ),
      _buildStep(
        icon: Icons.bolt_rounded,
        title: 'Analyze Content',
        description: 'Our smart AI analyzes the news for signs of misinformation and fake claims.',
        iconColor: const Color(0xFF38B000), // Green
      ),
      _buildStep(
        icon: Icons.check_circle_rounded,
        title: 'Get Instant Result',
        description: 'See whether the news is real or fake, so you can make informed decisions.',
        iconColor: const Color(0xFFEF233C), // Red
      ),
    ];
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: _textColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: iconColor),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: _textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}