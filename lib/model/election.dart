class Election {
  String? contractAddress;
  String? img;

  Election({
    this.contractAddress,
    this.img,
  });

  // data from server
  factory Election.fromMap(map) {
    return Election(
      contractAddress: map['contractAddress'],
      img: map['img'],
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {
      'contractAddress': contractAddress,
      'img': img,
    };
  }

  @override
  String toString() {
    return 'Election{contractAddress: $contractAddress, img: $img}';
  }
}
