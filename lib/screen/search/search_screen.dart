import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vote/consts.dart';
import 'package:vote/model/election.dart';
import 'package:vote/model/election_contract.dart';
import 'package:vote/model/user.dart';
import 'package:vote/model/wallet.dart';
import 'package:vote/screen/search/election_stats_screen.dart';
import 'package:vote/service/contract_service.dart';
import 'package:vote/service/election_service.dart';
import 'package:vote/service/storage_service.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/service/wallet_service.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/party.dart';
import '../../widget/menu_widget.dart';
import '../../widget/search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

  String query = '';

  bool finishedList = false;
  List<ElectionContract> electionContractList = [];
  List<ElectionContract> searchedelectionContractList = [];

  List<Party> searchedPartyList = [];
  List<Party> partyList = [];

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
        userWallet =
            await walletService.getWallet(loggedInUser.idCard?['personalCode']);

        electionService.getAll().then((list) async {
          List<Election> electionList = list;
          for (Election election in electionList) {
            final eligible = await contractService.isEligible(
                ethClient!, election.contractAddress!, userWallet.address!);
            final voted = await contractService.alreadyVoted(
                ethClient!, election.contractAddress!, userWallet.address!);

            if (eligible[0] == true && voted[0] == true) {
              List<dynamic> electionInfo = await contractService
                  .getElectionInfo(ethClient!, election.contractAddress!);

              List<dynamic> candidatesNum = await contractService
                  .getCandidatesNum(ethClient!, election.contractAddress!);

              List<dynamic> totalVotes = await contractService.getTotalVotes(
                  ethClient!, election.contractAddress!);

              electionContractList.add(ElectionContract(
                  electionName: electionInfo[0],
                  country: electionInfo[1],
                  startDate: electionInfo[2],
                  endDate: electionInfo[3],
                  totalVotes: totalVotes[0].toInt(),
                  noOfCandidates: candidatesNum[0].toInt(),
                  contractAddress: election.contractAddress));
              // ElectionContract electionContract = ;
            }
          }

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
    ThemeData theme = Theme.of(context);

    if (loggedInUser.firstname == null || finishedList == false) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      if (query == '') {
        searchedelectionContractList = electionContractList;
      }

      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(children: <Widget>[
          Positioned(
            top: height * 0.14,
            height: height * 0.11,
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
                      "Explore details about the elections you've been a part of, including the candidates you voted for and the outcomes.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.scaffoldBackgroundColor),
                    )
                  ],
                )),
          ),
          Positioned(
              top: height * 0.25,
              height: height * 0.64,
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
                  child: Column(
                    children: [
                      buildSearch(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: searchedelectionContractList.length,
                        itemBuilder: (context, index) {
                          return buildElection(
                              searchedelectionContractList[index], theme);
                        },
                      ))
                    ],
                  ),
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
                      Icons.search,
                      color: theme.dialogBackgroundColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Search",
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

  Widget buildSearch() {
    return SearchWidget(
        text: query,
        hintText: 'Search for election',
        onChanged: searchElection);
  }

  Widget buildElection(ElectionContract election, ThemeData theme) {
    Widget img = Image.asset("assets/election/election.jpg");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MaterialButton(
        splashColor: theme.scaffoldBackgroundColor,
        onPressed: () async {
          //In order to use go back
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ElectionStatsScreen(
                        electionContract: election,
                      )));
        },
        child: Container(
          foregroundDecoration: const BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
          ),
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
                        (DateFormat('MM-dd-yyyy').parse(election.startDate!))),
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

  void searchElection(String query) {
    final searchElections = electionContractList.where((election) {
      final electionName = election.electionName!.toLowerCase();
      final search = query.toLowerCase();

      return electionName.contains(search);
    }).toList();

    setState(() {
      this.query = query;
      searchedelectionContractList = searchElections;
    });
  }
}
