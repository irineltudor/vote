import 'package:vote/model/candidate.dart';

class ElectionContract {
  String? electionName;
  String? country;
  String? startDate;
  String? endDate;
  int? noOfCandidates;
  int? totalVotes;
  List<Candidate>? candidateList;

  ElectionContract({
    this.electionName,
    this.country,
    this.noOfCandidates,
    this.startDate,
    this.endDate,
    this.totalVotes,
    this.candidateList,
  });
}
