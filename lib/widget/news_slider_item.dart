import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsSliderItem extends StatelessWidget {
  final bool isActive;
  final Article article;
  const NewsSliderItem(
      {super.key, required this.isActive, required this.article});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String imgUrl = "";
    if (article.urlToImage != null) {
      imgUrl = article.urlToImage!;
    }

    DateTime date = DateTime.parse(article.publishedAt!);
    int difference = DateTime.now().difference(date).inDays;

    String daysAgo = '${DateTime.now().difference(date).inDays} days ago';

    if (difference <= 1) {
      daysAgo = '${DateTime.now().difference(date).inDays} day ago';
    }

    return GestureDetector(
      onTap: () => _launchURL(article.url),
      child: FractionallySizedBox(
        widthFactor: 1.08,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: isActive ? 1 : 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child:
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
              ClipRRect(
                child: Image.network(imgUrl,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    errorBuilder: (context, url, error) {
                  return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: theme.primaryColor,
                    child: Center(
                      child: Text(
                        'No Image',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.transparent,
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      article.title!,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: Colors.white),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${article.author!} • $daysAgo",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  _launchURL(url) async {
    Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) throw 'Could not launch $url0';
  }
}
