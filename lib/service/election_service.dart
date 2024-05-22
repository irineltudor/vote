import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/model/election.dart';

class ElectionService {
  String collection = "election";
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<Election>> getAll() async {
    List<Election> electionList = [];
    await FirebaseFirestore.instance.collection(collection).get().then((value) {
      Election election;
      for (var element in value.docs) {
        election = Election.fromMap(element.data());
        electionList.add(election);
      }
    });

    return electionList;
  }
}
