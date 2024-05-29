import 'package:blur/blur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vote/consts.dart';
import 'package:vote/model/election_contract.dart';
import 'package:vote/model/user.dart';
import 'package:vote/model/wallet.dart';
import 'package:vote/screen/elections/election_screen.dart';
import 'package:vote/service/contract_service.dart';
import 'package:vote/service/election_service.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/service/wallet_service.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/election.dart';
import '../../widget/menu_widget.dart';

class ElectionsScreen extends StatefulWidget {
  const ElectionsScreen({super.key});

  @override
  State<ElectionsScreen> createState() => _ElectionsScreenState();
}

class _ElectionsScreenState extends State<ElectionsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final StorageService storageService = StorageService();
  final UserService userService = UserService();
  final ElectionService electionService = ElectionService();
  final ContractService contractService = ContractService();
  final WalletService walletService = WalletService();
  UserWallet userWallet = UserWallet();
  Client? httpClient;
  Web3Client? ethClient;

  List<Election> electionList = [];
  List<ElectionContract> electionContractList = [];

  bool finishedList = false;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(INFURA_URL, httpClient!);
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) async {
      loggedInUser = value;

      if (loggedInUser.status == 1) {
        userWallet = await walletService.getWallet(loggedInUser);

        electionService.getAll().then((list) async {
          electionList = list;
          for (Election election in electionList) {
            final eligible = await contractService.isEligible(
                ethClient!,
                election.contractAddress!,
                userWallet.address!,
                election.testContract!);
            final voted = await contractService.alreadyVoted(
                ethClient!,
                election.contractAddress!,
                userWallet.address!,
                election.testContract!);

            final finished = await contractService.hasFinished(
                ethClient!,
                election.contractAddress!,
                userWallet.address!,
                election.testContract!);

            if (eligible[0] == true &&
                voted[0] == false &&
                finished[0] == false) {
              List<dynamic> result1 = await contractService.getElectionInfo(
                  ethClient!,
                  election.contractAddress!,
                  election.testContract!);

              List<dynamic> result2 = await contractService.getCandidatesNum(
                  ethClient!,
                  election.contractAddress!,
                  election.testContract!);

              electionContractList.add(ElectionContract(
                  electionName: result1[0],
                  country: result1[1],
                  startDate: result1[2].toInt(),
                  duration: result1[3].toInt(),
                  noOfCandidates: result2[0].toInt(),
                  contractAddress: election.contractAddress,
                  testContract: election.testContract!));
              // ElectionContract electionContract = ;
            }
          }

          electionContractList
              .sort((a, b) => a.startDate!.compareTo(b.startDate!));

          finishedList = true;
          if (mounted) {
            setState(() {});
          }
        });
      } else {
        finishedList = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    if (loggedInUser.firstname == null || finishedList == false) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      int count = electionContractList.length;

      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(children: <Widget>[
          Positioned(
            top: height * 0.14,
            height: height * 0.1,
            left: 0,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                padding: const EdgeInsets.only(
                    top: 10, left: 32, right: 32, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"Your Voice, Your Vote:',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.scaffoldBackgroundColor),
                    ),
                    Text(
                      'Every Ballot Shapes Our Future!"',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.scaffoldBackgroundColor),
                    ),
                  ],
                )),
          ),
          Positioned(
              top: height * 0.24,
              height: height * 0.65,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(45), top: Radius.circular(45)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(45), top: Radius.circular(45)),
                    color: theme.scaffoldBackgroundColor,
                  ),
                  child: loggedInUser.status == 1 &&
                          loggedInUser.phoneNumber != ''
                      ? Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                    ),
                                    child: Center(
                                        child: Text(
                                            "There are $count elections")))),
                            Expanded(
                                flex: 15,
                                child: ListView.builder(
                                    itemCount: count,
                                    itemBuilder: (context, index) {
                                      return buildElection(
                                          electionContractList[index], theme);
                                    })),
                          ],
                        )
                      : Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                              Blur(
                                blur: 10,
                                blurColor: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(45),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(45))),
                                  child: ListView.builder(
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return buildBlurredElections(theme);
                                      }),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: theme.scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(45))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    loggedInUser.phoneNumber == ''
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.not_interested,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "2FA",
                                                style: theme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                        color: Colors.red),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.verified,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                "2FA",
                                                style: theme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                    loggedInUser.status == 0
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.not_interested,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "ID CARD",
                                                style: theme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                        color: Colors.red),
                                              ),
                                            ],
                                          )
                                        : loggedInUser.status == 1
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(
                                                    "VERIFIED ID CARD",
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            color: Colors.blue),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .arrow_drop_down_circle,
                                                    color: Colors.orange,
                                                  ),
                                                  Text(
                                                    "WAITING ID CARD",
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            color:
                                                                Colors.orange),
                                                  ),
                                                ],
                                              ),
                                  ],
                                ),
                              ),
                            ]),
                ),
              )),
          Positioned(
            top: 0,
            height: height * 0.14,
            left: 0,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(45)),
                ),
                padding: const EdgeInsets.only(
                    top: 10, left: 32, right: 32, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.ballot,
                      color: theme.dialogBackgroundColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Elections",
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                )),
          ),
          Positioned(
              top: height * 0.04,
              height: height * 0.05,
              left: 0,
              right: height / 2.5,
              child: const MenuWidget()),
        ]),
      );
    }
  }

  Widget buildElection(ElectionContract election, ThemeData theme) {
    Widget img = Image.asset("assets/election/election.jpg");

    final today = DateTime.now();
    final electionDate =
        DateTime.fromMillisecondsSinceEpoch(election.startDate! * 1000);

    final difference = today.difference(electionDate).inSeconds;
    final active = difference >= 0 ? difference <= election.duration! : false;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MaterialButton(
        splashColor: theme.scaffoldBackgroundColor,
        onPressed: () async {
          //In order to use go back

          if (active) {
            final refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ElectionScreen(
                          electionContract: election,
                        )));

            if (refresh == "refresh") {
              setState(() {
                electionList = [];
                electionContractList = [];
                finishedList = false;
              });

              getData();
            }
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)],
          ),
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
            ClipRRect(borderRadius: BorderRadius.circular(30), child: img),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: active ? theme.primaryColor : Colors.grey,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                // border: Border.all(color: Colors.black, width: 2),
                // boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
                // gradient: LinearGradient(colors: [
                //   Colors.black,
                //   Colors.transparent,
                // ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    election.electionName!,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    "${election.noOfCandidates} Candidates",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    DateFormat('d MMMM yyyy on EEEE').format(
                        (DateTime.fromMillisecondsSinceEpoch(
                            election.startDate! * 1000))),
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
    );
  }

  Widget buildBlurredElections(ThemeData theme) {
    Widget img = Image.asset("assets/election/election.jpg");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MaterialButton(
        splashColor: theme.scaffoldBackgroundColor,
        onPressed: () {},
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)],
          ),
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
            ClipRRect(borderRadius: BorderRadius.circular(30), child: img),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                // border: Border.all(color: Colors.black, width: 2),
                // boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
                // gradient: LinearGradient(colors: [
                //   Colors.black,
                //   Colors.transparent,
                // ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Election Name",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    "X Candidates",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    "Election date",
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
    );
  }
}
