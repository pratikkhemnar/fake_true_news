import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
        child: Text(
          "No history available yet!",
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                item['text']!,
                style: GoogleFonts.poppins(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "Prediction: ${item['prediction']}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: item['prediction'] == "Fake News"
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}