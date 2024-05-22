import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;

class Article {
  final String title;
  final String description;

  Article({required this.title, required this.description});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}


class NewsApp extends StatelessWidget {
  Future<List<Article>> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=44e183eb307d45648fa402c90d485a14'));
      var jsonData = convert.jsonDecode(response.body) ;
        print( jsonData );
      final articles = (jsonData['articles'] as List)
          .map((articleJson) =>
              Article(title: articleJson['title'], description: articleJson['description']))
          .toList();
      return articles;
    } 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false , 
      home: Scaffold(
        appBar: AppBar(title: Text('centered')),
        body: FutureBuilder<List<Article>>(
          future: fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading news'));
            }else {
  final articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ListTile(
                    title: Text(article.title),
                    subtitle: Text(article.description),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
