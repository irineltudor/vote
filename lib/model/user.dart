class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? lastname;
  String? dob;
  String? pin;
  int? status; // 0-unverified,1-verified,2-waiting
  Map<String, dynamic>? idCard;

  UserModel(
      {this.uid,
      this.email,
      this.firstname,
      this.lastname,
      this.dob,
      this.pin,
      this.status,
      this.idCard});

  // data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      dob: map['dob'],
      pin: map['pin'],
      status: map['status'],
      idCard: Map<String, dynamic>.from(map['idCard']),
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'pin': pin,
      'status': status,
      'idCard': idCard,
    };
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, email: $email, firstname: $firstname, lastname: $lastname, dob: $dob,pin: $pin, status: $status, idCard: $idCard}';
  }
}
