import 'package:vote/model/candidate.dart';

class ElectionContract {
  String? contractAddress;
  String? electionName;
  String? country;
  int? startDate;
  int? duration;
  int? noOfCandidates;
  int? totalVotes;
  bool? testContract;
  List<Candidate>? candidateList;

  ElectionContract(
      {this.electionName,
      this.country,
      this.noOfCandidates,
      this.startDate,
      this.duration,
      this.totalVotes,
      this.candidateList,
      this.contractAddress,
      this.testContract});
}
