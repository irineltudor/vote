class Wallet {
  String? address;
  String? privateKey;

  Wallet({
    this.address,
    this.privateKey,
  });

  // data from server
  factory Wallet.fromMap(map) {
    return Wallet(
      address: map['address'],
      privateKey: map['privateKey'],
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'privateKey': privateKey,
    };
  }

  @override
  String toString() {
    return 'Wallet{address: $address, privateKey: $privateKey}';
  }
}
