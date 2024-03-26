import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../model/party.dart';

class PartyScreen extends StatefulWidget {
  Party party;
  PartyScreen({super.key, required this.party});

  @override
  State<PartyScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<PartyScreen> {
  int status = 0; // 0-unverified,1-waiting,2-verified

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Party party = widget.party;

    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: Colors.black,
            expandedHeight: 200,
            iconTheme: IconThemeData(
                color: theme.scaffoldBackgroundColor,
                size: 25,
                shadows: const [Shadow(blurRadius: 6, color: Colors.black)]),
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
                          child: party.img),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  // border: Border.all(color: Colors.black, width: 5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 4)
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: ListTile(
                title: Text(
                  '${party.name}',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width / 1.1,
              height: 500,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 4)
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ListTile(
                    title: Text(
                      'Party Members:',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 410,
                    child: ListView.builder(
                        itemCount: party.memberList.length,
                        itemBuilder: (context, index) {
                          return _memberCard(member: party.memberList[index]);
                        }),
                  ),
                ],
              ),
            )
          ])),
          // SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //   childCount: party.memberList.length,
          //   (context, index) {
          //     return _memberCard(member: party.memberList[index]);
          //   },
          // ))
        ]));
  }

  Widget _memberCard({required String member}) {
    final img = Image.asset(
      'assets/election/candidate.png',
    );

    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        openDetailsDialog(member);
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(color: Color.fromARGB(246, 0, 0, 0), blurRadius: 4)
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
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
                      member,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> openDetailsDialog(String member) {
    final img = Image.asset(
      'assets/election/candidate.png',
    );
    ThemeData theme = Theme.of(context);

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
                            member,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
