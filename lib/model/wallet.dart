class UserWallet {
  String? address;
  String? privateKey;

  UserWallet({
    this.address,
    this.privateKey,
  });

  // data from server
  factory UserWallet.fromMap(map) {
    return UserWallet(
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
    return 'UserWallet{address: $address, privateKey: $privateKey}';
  }
}
