import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:http/http.dart';
import 'package:vote/consts.dart';
import 'package:vote/model/election_contract.dart';
import 'package:vote/model/user.dart';
import 'package:vote/model/wallet.dart';
import 'package:vote/service/contract_service.dart';
import 'package:vote/service/election_service.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/service/wallet_service.dart';
import 'package:vote/widget/radial_progress_widget.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/candidate.dart';

class ElectionStatsScreen extends StatefulWidget {
  final ElectionContract electionContract;
  const ElectionStatsScreen({super.key, required this.electionContract});

  @override
  State<ElectionStatsScreen> createState() => _ElectionStatsScreenState();
}

class _ElectionStatsScreenState extends State<ElectionStatsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final StorageService storageService = StorageService();
  final UserService userService = UserService();
  final ElectionService electionService = ElectionService();
  final ContractService contractService = ContractService();
  final WalletService walletService = WalletService();
  ElectionContract electionContract = ElectionContract();
  UserWallet userWallet = UserWallet();
  Client? httpClient;
  Web3Client? ethClient;

  List<Candidate> candidateList = [];
  List<Color> colorList = [];

  bool sorted = false;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(INFURA_URL, httpClient!);
    electionContract = widget.electionContract;
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) async {
      loggedInUser = value;
      if (loggedInUser.status == 1) {
        userWallet = await walletService.getWallet(loggedInUser);
      }
      if (mounted) {
        setState(() {});
      }
    });

    colorList = getColorList(electionContract.noOfCandidates!);

    for (int i = 0; i < electionContract.noOfCandidates!; i++) {
      List<dynamic> candidateInfo = await contractService.getCandidateInfo(
          ethClient!,
          electionContract.contractAddress!,
          i,
          electionContract.testContract!);
      Candidate candidate = Candidate(
          name: candidateInfo[0],
          about: candidateInfo[1],
          numVotes: candidateInfo[2].toInt());
      candidateList.add(candidate);
    }

    candidateList.sort((a, b) => a.numVotes < b.numVotes
        ? 1
        : a.numVotes == b.numVotes
            ? 0
            : -1);

    sorted = true;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (loggedInUser.status == null || candidateList.isEmpty || !sorted) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      int noCandidates = candidateList.length;

      Widget img = Image.asset(
        "assets/election/election.jpg",
        fit: BoxFit.cover,
      );

      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: Colors.black,
            expandedHeight: 200,
            iconTheme: const IconThemeData(
                color: Colors.white,
                size: 25,
                shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40))),
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
                          child: Container(
                              foregroundDecoration: const BoxDecoration(
                                color: Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              child: img)),
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
                electionContract.electionName!,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.scaffoldBackgroundColor),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '${electionContract.noOfCandidates} Candidates',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.scaffoldBackgroundColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(246, 0, 0, 0), blurRadius: 4)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: RadialProgress(
                        candidateList: candidateList,
                        totalVotes: electionContract.totalVotes!,
                        colorList: colorList,
                        height: 130,
                        width: 130),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(flex: 7, child: topCandidates(theme))
                ],
              ),
            ),
            Container(
              height: 362,
              padding: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(color: theme.primaryColor),
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
                              candidate: candidateList[first],
                              theme: theme,
                              index: first,
                              color: colorList[first]),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _canditateCard(
                              candidate: candidateList[first],
                              theme: theme,
                              index: first,
                              color: colorList[first]),
                          _canditateCard(
                              candidate: candidateList[second],
                              theme: theme,
                              index: second,
                              color: colorList[second]),
                        ],
                      );
                    }
                  }),
            )
          ])),
        ]),
      );
    }
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
              Navigator.of(context).pop("confirm");
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
              margin: const EdgeInsets.only(top: 550),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(45))),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(flex: 1, child: ClipOval(child: img)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            candidate.name,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            candidate.about,
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            candidate.numVotes == 1
                                ? '${candidate.numVotes} vote'
                                : '${candidate.numVotes} votes',
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
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
      required int index,
      required Color color}) {
    final img = Image.asset(
      'assets/election/candidate.png',
    );

    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        height: 200,
        width: 170,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color: theme.scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(246, 0, 0, 0), blurRadius: 4)
            ]),
        duration: const Duration(milliseconds: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(70))),
                  child: ClipOval(child: img)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        candidate.name.length > 32
                            ? '${candidate.name.substring(0, 32)}...'
                            : candidate.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          openDetailsDialog(candidate, theme);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: theme.dialogBackgroundColor,
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

  List<Color> getColorList(int number) {
    List<Color> colorList = [];
    Options options = Options(
      format: Format.rgbArray,
      luminosity: Luminosity.dark,
      count: number,
    );
    var colors = RandomColor.getColor(options);
    for (int i = 0; i < number; i++) {
      Color color = Color.fromRGBO(colors[i][0], colors[i][1], colors[i][2], 1);
      colorList.add(color);
    }
    return colorList;
  }

  Widget topCandidates(ThemeData theme) {
    return Center(
      child: ListView.builder(
          itemCount: candidateList.length < 5 ? candidateList.length : 5,
          itemBuilder: (context, index) {
            Candidate candidate = candidateList[index];
            return Row(children: [
              SizedBox(
                width: 12.5,
                height: 12.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colorList[index]),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${(candidate.numVotes / electionContract.totalVotes! * 100).floor()}%',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                candidate.name.length > 15
                    ? '${candidate.name.substring(0, 15)}...'
                    : candidate.name,
                style: theme.textTheme.bodyLarge,
              ),
            ]);
          }),
    );
  }
}
