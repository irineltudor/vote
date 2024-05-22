import 'package:flutter/services.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString('assets/abi/abi.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "ElectionTesting"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> callFunction(String functionName, List<dynamic> args,
      Web3Client ethClient, String privateKey, String contractAddress) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args));

    return result;
  }

  Future<String> vote(int candidateIndex, Web3Client ethClient,
      String privateKey, String contractAddress) async {
    var response = await callFunction("vote", [BigInt.from(candidateIndex)],
        ethClient, privateKey, contractAddress);
    print("Vote Counted Succesfully");
    return response;
  }

  Future<List<dynamic>> ask(String functionName, List<dynamic> args,
      Web3Client ethClient, String contractAddress) async {
    final contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);
    final result =
        ethClient.call(contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<List> getCandidatesNum(
      Web3Client ethClient, String contractAddress) async {
    List<dynamic> result =
        await ask('getNumOfCandidates', [], ethClient, contractAddress);
    return result;
  }

  Future<List> getElectionInfo(
      Web3Client ethClient, String contractAddress) async {
    List<dynamic> result =
        await ask('getElectionInfo', [], ethClient, contractAddress);
    return result;
  }
}
