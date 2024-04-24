import 'package:flutter/material.dart';
import 'package:vote/screen/search/party_screen.dart';

import '../../model/party.dart';
import '../../widget/menu_widget.dart';
import '../../widget/search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List<Party> searchedPartyList = [];
  List<Party> partyList = [];

  @override
  void initState() {
    super.initState();

    List<String> parties = [
      "Unity Alliance Party",
      "Progressive Coalition",
      "Liberty Front",
      "Future Vision Party",
      "People's Harmony Party",
      "New Horizon Movement",
      "Justice and Equality Party"
    ];

    List<String> members = [
      "Sarah Johnson",
      "David Chen",
      "Maria Rodriguez",
      "Ahmed Khan",
      "Emily Thompson",
      "Jamal Patel",
      "Natasha Lee",
      "Juan Ramirez",
      "Sophie Anderson",
      "Aliyah Williams",
      "Michael Brown",
      "Olivia Garcia",
      "Samuel Miller",
      "Emma Davis",
      "Joshua Wilson",
      "Isabella Martinez",
      "Ethan Taylor",
      "Mia Lopez",
      "Jacob Clark",
      "Sophia Nguyen",
      "Aiden Carter",
    ];

    for (var i = 0; i < parties.length; i++) {
      partyList.add(Party(
          name: parties[i],
          memberList: List.from(
              [members[3 * i + 0], members[3 * i + 1], members[3 * i + 2]]),
          img: Image.asset(
            "assets/party/party.jpg",
            fit: BoxFit.fitWidth,
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    ThemeData theme = Theme.of(context);

    if (query == '') {
      searchedPartyList = partyList;
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
                    "Here you can search details about any candidate or party that are currently running in an election",
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
                      itemCount: searchedPartyList.length,
                      itemBuilder: (context, index) {
                        return buildParty(searchedPartyList[index]);
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

  Widget buildSearch() {
    return SearchWidget(
        text: query, hintText: 'Search for party', onChanged: searchTournament);
  }

  Widget buildParty(Party party) {
    return MaterialButton(
        splashColor: Colors.grey,
        onPressed: () {
          //In order to use go back
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PartyScreen(party: party)));
        },
        child: ListTile(
          title: Text(party.name),
          subtitle: Text(party.memberList.join(" , ")),
          trailing: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(45),
              top: Radius.circular(45),
            ),
            child: party.img,
          ),
        ));
  }

  void searchTournament(String query) {
    final searchParties = partyList.where((party) {
      final partyName = party.name.toLowerCase();
      final search = query.toLowerCase();
      final partyMemberList = party.memberList.join(" , ").toLowerCase();

      if (partyName.contains(search)) {
        return partyName.contains(search);
      } else {
        return partyMemberList.contains(search);
      }
    }).toList();

    setState(() {
      this.query = query;
      searchedPartyList = searchParties;
    });
  }
}
