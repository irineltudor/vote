import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widget/menu_widget.dart';
import '../../widget/news_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(children: <Widget>[
        Positioned(
            top: 0,
            height: height * 0.17,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(45)),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 21, left: 32, right: 32, bottom: 10),
                color: theme.scaffoldBackgroundColor,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            "${DateFormat("EEEE").format(DateTime.now())}, ${DateFormat("d MMMM").format(DateTime.now())}",
                            style: theme.textTheme.bodySmall),
                        subtitle: Text("Hello, Tudor",
                            style: theme.textTheme.headlineLarge),
                        trailing: ClipOval(
                            child: Image.asset("assets/profile/profile.jpg")),
                      )
                    ]),
              ),
            )),
        Positioned(
            top: height * 0.04,
            height: height * 0.05,
            left: 0,
            right: height / 2.5,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
              child: MenuWidget(),
            )),
        Positioned(
            top: height * 0.19,
            height: height * 0.7,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: const Radius.circular(45),
                  bottom: const Radius.circular(45)),
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Campaings",
                          style: theme.textTheme.headlineMedium,
                        ),
                        GestureDetector(
                          onTap: () => {},
                          child: Text(
                            "View all",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NewsSlider(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "News",
                          style: theme.textTheme.headlineMedium,
                        ),
                        GestureDetector(
                          onTap: () => {},
                          child: Text(
                            "View all",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NewsSlider(),
                ]),
              ),
            )),
      ]),
    );
  }
}
