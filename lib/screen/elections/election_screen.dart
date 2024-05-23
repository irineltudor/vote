import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/consts.dart';
import 'package:vote/model/election_contract.dart';
import 'package:vote/model/user.dart';
import 'package:vote/model/wallet.dart';
import 'package:vote/service/contract_service.dart';
import 'package:vote/service/election_service.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/service/wallet_service.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/candidate.dart';

class ElectionScreen extends StatefulWidget {
  final ElectionContract electionContract;
  const ElectionScreen({super.key, required this.electionContract});

  @override
  State<ElectionScreen> createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
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

  int selectedCandidateIndex = -1;
  bool voteProcessing = false;

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
        userWallet =
            await walletService.getWallet(loggedInUser.idCard?['personalCode']);
      }
      if (mounted) {
        setState(() {});
      }
    });

    for (int i = 0; i < electionContract.noOfCandidates!; i++) {
      List<dynamic> candidateInfo = await contractService.getCandidateInfo(
          ethClient!, electionContract.contractAddress!, i);
      Candidate candidate = Candidate(
          name: candidateInfo[0],
          about: candidateInfo[1],
          numVotes: candidateInfo[2].toInt());
      candidateList.add(candidate);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    if (loggedInUser.status == null || candidateList.isEmpty) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      if (voteProcessing == true) {
        return Container(
          color: theme.primaryColor,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                    "assets/animations/waiting_transaction_animation.json"),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Awaiting the processing of your vote.",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.scaffoldBackgroundColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  color: theme.scaffoldBackgroundColor,
                )
              ]),
        );
      } else {
        int noCandidates = candidateList.length;

        Widget img = Image.asset(
          "assets/election/election.jpg",
          fit: BoxFit.cover,
        );

        final voteButton = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: selectedCandidateIndex != -1
                  ? theme.primaryColor
                  : Colors.grey,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                selectedCandidateIndex != -1
                    ? BoxShadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 10)
                    : const BoxShadow()
              ]),
          child: SizedBox(
            width: width,
            child: Material(
                color: Colors.transparent,
                child: TextButton(
                    onPressed: selectedCandidateIndex != -1
                        ? () async {
                            final confirm = await openDialog(
                                candidateList[selectedCandidateIndex].name,
                                theme);
                            if (confirm == "confirm") {
                              contractService
                                  .vote(
                                      selectedCandidateIndex,
                                      ethClient!,
                                      userWallet.privateKey!,
                                      electionContract.contractAddress!)
                                  .then((value) async {
                                setState(() {
                                  voteProcessing = true;
                                });
                                while ((await ethClient!
                                        .getTransactionReceipt(value)) ==
                                    null) {
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                }

                                Fluttertoast.showToast(
                                  msg:
                                      "Congrats! You voted for ${candidateList[selectedCandidateIndex].name}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                );
                                if (mounted) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop("refresh");
                                }
                              });
                            }
                          }
                        : null,
                    child: Text(
                      "Vote",
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(color: Colors.white),
                    ))),
          ),
        );

        final DateTime date =
            DateFormat('MM-dd-yyyy').parse(electionContract.startDate!);
        final int remaining = date.difference(DateTime.now()).inHours;

        return Scaffold(
          backgroundColor: theme.primaryColor,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 20),
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
                            "$remaining hours left",
                            style: theme.textTheme.titleMedium,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
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
                  electionContract.electionName!,
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: theme.scaffoldBackgroundColor),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  '${electionContract.noOfCandidates} Candidates',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.scaffoldBackgroundColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.all(10),
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
                                candidate: candidateList[first],
                                theme: theme,
                                index: first),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _canditateCard(
                                candidate: candidateList[first],
                                theme: theme,
                                index: first),
                            _canditateCard(
                                candidate: candidateList[second],
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCandidateIndex = index;
        });
      },
      child: AnimatedContainer(
        height: 200,
        width: 170,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color:
                isSelected ? theme.primaryColor : theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(246, 0, 0, 0),
                  blurRadius: isSelected ? 0 : 4)
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
                      color: isSelected
                          ? theme.scaffoldBackgroundColor
                          : theme.primaryColor.withOpacity(0.5),
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
                        style: isSelected
                            ? theme.textTheme.labelMedium
                                ?.copyWith(color: theme.scaffoldBackgroundColor)
                            : theme.textTheme.labelMedium,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          openDetailsDialog(candidate, theme);
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
