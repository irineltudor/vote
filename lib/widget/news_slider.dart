import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

import '../consts.dart';
import 'news_slider_item.dart';

class NewsSlider extends StatefulWidget {
  const NewsSlider({super.key});

  @override
  State<NewsSlider> createState() => _NewsSliderState();
}

class _NewsSliderState extends State<NewsSlider> {
  late final PageController _pageController;

  final NewsAPI _newsApi = NewsAPI(apiKey: NEWS_API_KEY);
  List<Article> articles = [];

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  Future<void> getData() async {
    await _newsApi
        .getEverything(
      query: 'politics&romania-tate',
    )
        .then((value) {
      setState(() {
        value.removeWhere((element) {
          return element.author == null ||
              element.content == null ||
              element.url == null ||
              element.title == null ||
              element.urlToImage == null ||
              element.description == null ||
              element.publishedAt == null;
        });

        articles = value;
      });
    }).catchError((cathcedError) {
      ApiError error = cathcedError as ApiError;
      // ignore: avoid_print
      print("Error ${error.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    ThemeData theme = Theme.of(context);

    if (articles.isEmpty) {
      return Container(
          height: height / 4,
          color: theme.scaffoldBackgroundColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.dialogBackgroundColor,
          )));
    } else {
      return SizedBox(
        height: height / 4,
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              _pageIndex = value % articles.length;
            });
          },
          controller: _pageController,
          itemBuilder: (context, index) {
            final i = index % articles.length;
            return NewsSliderItem(
              isActive: _pageIndex == i,
              article: articles[i],
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
