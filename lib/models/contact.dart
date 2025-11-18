class myContactModel {
  int? id;
  final String?firstName;
  final String?lastName;
  final String email;
  final String phone;
  final String? photoUrl;

  myContactModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photoUrl,
  });

  // Convert object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  // Convert Map → Object (for DB fetch)
  factory myContactModel.fromMap(Map<String, dynamic> map) {
    return myContactModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
    );
  }

  @override
  String toString() {
    return 'contact{id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, photoUrl: $photoUrl}';
  }
}
