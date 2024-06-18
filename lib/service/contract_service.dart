import 'package:flutter/services.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  final String testAbiPath = "assets/abi/abi.json";
  final String testName = "ElectionTest";
  final String abiPath = "assets/abi/election_abi.json";
  final String name = "Election";

  Future<DeployedContract> loadContract(
      String contractAddress, bool testContract) async {
    final path = testContract ? testAbiPath : abiPath;
    final contractName = testContract ? testName : name;
    String abi = await rootBundle.loadString(path);
    final contract = DeployedContract(ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> callFunction(
      String functionName,
      List<dynamic> args,
      Web3Client ethClient,
      String privateKey,
      String contractAddress,
      bool testContract) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract =
        await loadContract(contractAddress, testContract);
    final nonce = await ethClient.getTransactionCount(credentials.address,
        atBlock: const BlockNum.pending());
    final ethFunction = contract.function(functionName);

    final yourFunctionData = ethFunction.encodeCall(args);
    // Estimate gas
    final estimatedGas = await ethClient.estimateGas(
      sender: credentials.address,
      to: contract.address,
      data: yourFunctionData,
    );

    // ignore: avoid_print
    print(estimatedGas);

    // Set the gas limit to estimatedGas + some buffer
    final gasLimit = estimatedGas + BigInt.from(10000); // Adding buffer

    // Get gas price
    final gasPrice = await ethClient.getGasPrice();
// ignore: avoid_print
    print(
        "PRICE in eth: ${(gasPrice.getInWei.toInt() * estimatedGas.toInt() / 1000000000000000000)}");
// ignore: avoid_print
    print(
        "PRICE in eth for me: ${(100000000000 * estimatedGas.toInt() / 1000000000000000000)}");

    final result = await ethClient
        .sendTransaction(
            credentials,
            chainId: 11155111,
            Transaction.callContract(
                from: contract.address,
                contract: contract,
                function: ethFunction,
                maxGas: gasLimit.toInt(),
                // maxFeePerGas: gasPrice,
                // EtherAmount.fromInt(EtherUnit.wei, 10000000000),
                nonce: nonce,
                parameters: args))
        .catchError((errorCatched) {
      RPCError error = errorCatched as RPCError;

      return error.message;
    });

    return result;
  }

  Future<String> vote(int candidateIndex, Web3Client ethClient,
      String privateKey, String contractAddress, bool testContract) async {
    var response = await callFunction("vote", [BigInt.from(candidateIndex)],
        ethClient, privateKey, contractAddress, testContract);
    return response;
  }

  Future<List<dynamic>> ask(String functionName, List<dynamic> args,
      Web3Client ethClient, String contractAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function(functionName);
    final result = ethClient
        .call(contract: contract, function: ethFunction, params: args)
        .onError((error, stackTrace) {
      // ignore: avoid_print
      print(error);
      return [];
    });

    return result;
  }

  Future<List> getCandidatesNum(
      Web3Client ethClient, String contractAddress, bool testContract) async {
    List<dynamic> result = await ask(
        'getNumOfCandidates', [], ethClient, contractAddress, testContract);
    return result;
  }

  Future<List> getElectionInfo(
      Web3Client ethClient, String contractAddress, bool testContract) async {
    List<dynamic> result = await ask(
        'getElectionInfo', [], ethClient, contractAddress, testContract);
    return result;
  }

  Future<List> getCandidateInfo(Web3Client ethClient, String contractAddress,
      int candidateIndex, bool testContract) async {
    List<dynamic> result = await ask(
        'getCandidateInfo',
        [BigInt.from(candidateIndex)],
        ethClient,
        contractAddress,
        testContract);
    return result;
  }

  Future<List> getVoter(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    List<dynamic> result = await ask(
        '_eligibleVoters',
        [EthereumAddress.fromHex(senderAddress)],
        ethClient,
        contractAddress,
        testContract);
    return result;
  }

  Future<List> getTotalVotes(
      Web3Client ethClient, String contractAddress, bool testContract) async {
    List<dynamic> result = await ask(
        'getTotalVotes', [], ethClient, contractAddress, testContract);
    return result;
  }

  Future<List> isEligible(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function("isEligible");
    final result = ethClient.call(
        sender: EthereumAddress.fromHex(senderAddress),
        contract: contract,
        function: ethFunction,
        params: []);

    return result;
  }

  Future<List> alreadyVoted(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function("alreadyVoted");
    final result = ethClient.call(
        sender: EthereumAddress.fromHex(senderAddress),
        contract: contract,
        function: ethFunction,
        params: []);

    return result;
  }

  Future<List> hasStarted(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function("hasStarted");
    final result = ethClient.call(
        sender: EthereumAddress.fromHex(senderAddress),
        contract: contract,
        function: ethFunction,
        params: []);

    return result;
  }

  Future<List> hasFinished(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function("hasFinished");
    final result = ethClient.call(
        sender: EthereumAddress.fromHex(senderAddress),
        contract: contract,
        function: ethFunction,
        params: []);

    return result;
  }

  Future<List> isRunning(Web3Client ethClient, String contractAddress,
      String senderAddress, bool testContract) async {
    final contract = await loadContract(contractAddress, testContract);
    final ethFunction = contract.function("isRunning");
    final result = ethClient.call(
        sender: EthereumAddress.fromHex(senderAddress),
        contract: contract,
        function: ethFunction,
        params: []);

    return result;
  }
}
