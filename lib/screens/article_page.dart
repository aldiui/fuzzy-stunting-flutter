import 'package:flutter/material.dart';
import 'package:stunting_android/services/api_service.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<dynamic>? articles;
  int? selectedArticleIndex;

  Future<void> fetchArticles() async {
    final apiService = ApiService();
    try {
      final response = await apiService.getArtikel();
      setState(() {
        articles = response['data'];
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal memuat artikel: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        centerTitle: true,
        leading: selectedArticleIndex != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedArticleIndex = null;
                  });
                },
              )
            : null,
      ),
      body: articles == null
          ? const Center(child: CircularProgressIndicator())
          : articles!.isEmpty
              ? const Center(child: Text('Tidak ada artikel ditemukan'))
              : selectedArticleIndex == null
                  ? _buildArticleList()
                  : _buildArticleDetail(articles![selectedArticleIndex!]),
    );
  }

  Widget _buildArticleList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles!.length,
      itemBuilder: (context, index) {
        final article = articles![index];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedArticleIndex = index;
            });
          },
          child: _buildArticleCard(
            article['id'],
            article['judul'],
            article['created_at'],
            article['gambar'],
          ),
        );
      },
    );
  }

  Widget _buildArticleCard(
      int id, String judul, String createdAt, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  createdAt,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleDetail(dynamic article) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(article['gambar']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article['judul'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article['created_at'],
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            HtmlWidget(article['deskripsi']),
          ],
        ),
      ),
    );
  }
}
