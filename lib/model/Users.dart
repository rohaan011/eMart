class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phoneNumber;
  String? profileImage;

  Users({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.profileImage,
  });

  Users fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'] ?? "",
      profileImage: json['profileImage'] ?? "https://via.placeholder.com/150",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }
}
