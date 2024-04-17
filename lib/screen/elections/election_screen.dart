import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../model/candidate.dart';

class ElectionScreen extends StatefulWidget {
  String electionId;
  ElectionScreen({super.key, required this.electionId});

  @override
  State<ElectionScreen> createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool alreadyVoted = false;
  int selectedCandidateIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final String electionId = widget.electionId;

    int noCandidates = 7;
    print("$selectedCandidateIndex === $alreadyVoted");

    Widget img = Image.asset(
      "assets/election/election.jpg",
      fit: BoxFit.cover,
    );

    final voteButton = AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: (!alreadyVoted) && selectedCandidateIndex != -1
              ? theme.primaryColor
              : Colors.grey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            (!alreadyVoted) && selectedCandidateIndex != -1
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.5), blurRadius: 10)
                : const BoxShadow()
          ]),
      child: SizedBox(
        width: width,
        child: Material(
            color: Colors.transparent,
            child: TextButton(
                child: Text(
                  "Vote",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                onPressed: (!alreadyVoted) && selectedCandidateIndex != -1
                    ? () =>
                        {openDialog("candidate $selectedCandidateIndex", theme)}
                    : null)),
      ),
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: SizedBox(
                width: width / 2.3,
                child: Material(
                    elevation: 5,
                    color: theme.scaffoldBackgroundColor,
                    child: Center(
                      child: Text(
                        "1 day left",
                        style: theme.textTheme.titleMedium,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            voteButton
          ],
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          snap: true,
          floating: true,
          backgroundColor: Colors.black,
          expandedHeight: 200,
          iconTheme: IconThemeData(
              color: Colors.white,
              size: 25,
              shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40)),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40)),
                        child: img),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Election name',
              style: theme.textTheme.headlineLarge
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              'No of Candidates',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 660,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
            child: ListView.builder(
                itemCount: (noCandidates / 2).ceil(),
                itemBuilder: (context, index) {
                  int first = 2 * index;
                  int second = 2 * index + 1;

                  if (second > noCandidates - 1) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _canditateCard(
                            candidate: Candidate(), theme: theme, index: first),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _canditateCard(
                            candidate: Candidate(), theme: theme, index: first),
                        _canditateCard(
                            candidate: Candidate(),
                            theme: theme,
                            index: second),
                      ],
                    );
                  }
                }),
          )
        ])),
      ]),
    );
  }

  Future openDialog(String candidateName, ThemeData theme) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.primaryColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: theme.scaffoldBackgroundColor),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Image.asset("assets/election/candidate.png"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Vote for $candidateName",
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            )
          ],
        ),
        actions: [
          Text(
            "Are you sure?",
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(theme.scaffoldBackgroundColor),
            ),
            child: Text(
              "Confirm",
              style: theme.textTheme.bodyLarge,
            ),
          )
        ],
      ),
    );
  }

  Future<void> openDetailsDialog(Candidate candidate, ThemeData theme) {
    final img = Image.asset(
      'assets/election/candidate.png',
    );

    return showDialog(
        context: context,
        builder: (context) => Container(
              margin: EdgeInsets.only(top: 400),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(45))),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(flex: 1, child: ClipOval(child: img)),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            "Candidate Name",
                            style: theme.textTheme.headlineMedium,
                          ),
                          Text(
                            "Candidate Party",
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            "Candidate details",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget _canditateCard(
      {required Candidate candidate,
      required ThemeData theme,
      required int index}) {
    final img = Image.asset(
      'assets/election/candidate.png',
    );

    bool isSelected = index == selectedCandidateIndex;
    bool candidateSelected = selectedCandidateIndex != -1;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCandidateIndex = index;
        });
      },
      child: AnimatedContainer(
        height: 200,
        width: 170,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color:
                isSelected ? theme.primaryColor : theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(246, 0, 0, 0),
                  blurRadius: isSelected ? 0 : 4)
            ]),
        duration: Duration(milliseconds: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? theme.scaffoldBackgroundColor
                          : theme.primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(70))),
                  child: ClipOval(child: img)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Candiate Name",
                      style: isSelected
                          ? theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.scaffoldBackgroundColor)
                          : theme.textTheme.bodyLarge,
                      maxLines: 1,
                    ),
                    IconButton(
                        onPressed: () {
                          openDetailsDialog(Candidate(), theme);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: isSelected
                              ? theme.scaffoldBackgroundColor
                              : theme.dialogBackgroundColor,
                          size: 20,
                        ))
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
