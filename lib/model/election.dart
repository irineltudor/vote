class Election {
  String? contractAddress;
  String? img;
  bool? testContract;

  Election({this.contractAddress, this.img, this.testContract});

  // data from server
  factory Election.fromMap(map) {
    return Election(
        contractAddress: map['contractAddress'],
        img: map['img'],
        testContract: map['testContract']);
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {
      'contractAddress': contractAddress,
      'img': img,
      'testContract': testContract
    };
  }

  @override
  String toString() {
    return 'Election{contractAddress: $contractAddress, img: $img, testContract : $testContract}';
  }
}
