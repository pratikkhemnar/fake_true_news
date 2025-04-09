import 'package:fake_true_news/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'about_screen.dart';
import 'history_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController newsController = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> searchHistory = [];

  Future<void> checkNews() async {
    String newsText = newsController.text.trim();
    if (newsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some news text!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse("http://localhost:8080/predict/");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": newsText}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String prediction = data["prediction"];

        setState(() {
          searchHistory.insert(0, {"text": newsText, "prediction": prediction});
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(prediction: prediction),
          ),
        );
      } else {
        throw Exception("Failed to get response");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Fake News Detector',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D2671), Color(0xFFC33764)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/img2.png',
                    height: 180,
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: TextField(
                      controller: newsController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Paste the news article...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isLoading ? null : checkNews,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Check News',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTextButton(
                        context,
                        'View History',
                        Icons.history,
                        HistoryScreen(history: searchHistory),
                      ),
                      _buildTextButton(
                        context,
                        'About App',
                        Icons.info_outline,
                        const AboutScreen(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextButton(
                    context,
                    'View News',
                    Icons.article,
                    const NewsScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String text, IconData icon, Widget screen) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
