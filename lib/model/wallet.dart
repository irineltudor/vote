class UserWallet {
  String? address;
  String? privateKey;
  String? owner;

  UserWallet({this.address, this.privateKey, this.owner});

  // data from server
  factory UserWallet.fromMap(map) {
    return UserWallet(
        address: map['address'],
        privateKey: map['privateKey'],
        owner: map['owner']);
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {'address': address, 'privateKey': privateKey, 'owner': owner};
  }

  @override
  String toString() {
    return 'UserWallet{address: $address, privateKey: $privateKey, owner: $owner}';
  }
}
