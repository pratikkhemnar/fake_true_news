
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import 'package:csv/csv.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<List<dynamic>> _fakeNews = [];
  List<List<dynamic>> _trueNews = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final fakeData = await rootBundle.loadString('assets/datasets/Fake.csv');
    final trueData = await rootBundle.loadString('assets/datasets/True.csv');

    List<List<dynamic>> fakeList = const CsvToListConverter().convert(fakeData);
    List<List<dynamic>> trueList = const CsvToListConverter().convert(trueData);

    // Remove headers
    fakeList.removeAt(0);
    trueList.removeAt(0);

    setState(() {
      _fakeNews = fakeList;
      _trueNews = trueList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News "),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Fake News"),
              Tab(text: "True News"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _newsList(_fakeNews, "Fake"),
            _newsList(_trueNews, "True"),
          ],
        ),
      ),
    );
  }

  Widget _newsList(List<List<dynamic>> newsData, String type) {
    return newsData.isEmpty
        ? const Center(
      child: Text(
        "No news available",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        final news = newsData[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news[0], // Title
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  news[1], // Description
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blueAccent),
                      onPressed: () => copyToClipboard(news[1]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("News copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
