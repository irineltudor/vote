import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  int status = 0; // 0-unverified,1-waiting,2-verified

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    setState(() {
      status = 2;
    });

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.scaffoldBackgroundColor),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          margin: EdgeInsets.only(left: 55),
          child: Text(
            "Account details ",
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
        ),
      ),
      body: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 250),
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                detailContainer("Email", "tirynel@yahoo.com"),
                detailContainer(
                    "Address", "Sarmisegetuza nr 12, bl Q1 , sc C , ap 17"),
                detailContainer("Country", "Romania"),
                detailContainer("Date of Birth", "11-09-2000"),
                detailContainer("personalCode", "5342912321321"),
              ],
            ),
          ),
        ),
        Container(
          height: 200,
          width: width,
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(color: theme.primaryColor),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: theme.scaffoldBackgroundColor, width: 3)),
              child: ClipOval(
                  child: Image.asset(
                "assets/profile/profile.jpg",
              )),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.only(left: 230, top: 50),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
              child: status == 0
                  ? const Icon(
                      Icons.not_interested,
                      color: Colors.red,
                    )
                  : status == 1
                      ? const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.orange,
                        )
                      : Icon(
                          Icons.verified,
                          color: theme.primaryColor,
                        )),
        ),
        Container(
          height: 80,
          width: width,
          margin: EdgeInsets.only(top: 160, left: 30, right: 30),
          decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)
              ]),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Urma Tudor-Irinel",
              style: theme.textTheme.titleLarge,
            ),
            Text(
              "23 years old",
              style: theme.textTheme.bodySmall,
            )
          ]),
        ),
      ]),
    );
  }

  Widget detailContainer(String detail, String text) {
    ThemeData theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 100,
      width: width,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail,
              style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.dialogBackgroundColor.withOpacity(0.8)),
            ),
            Text(
              text,
              style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.dialogBackgroundColor.withOpacity(0.8)),
            ),
          ]),
    );
  }
}
