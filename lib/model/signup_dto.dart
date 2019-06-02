class UserDTO {
  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String organizationName = "";
  String organizationCode = "";

  UserDTO();

  UserDTO.fromJson(Map<String, dynamic> data)
      : assert(data != null),
        firstName = data['firstName'] ?? "",
        lastName = data['lastName'] ?? "",
        email = data['email'] ?? "",
        phoneNumber = data['phoneNumber'] ?? "",
        organizationName = data['organizationName'] ?? "",
        organizationCode = data['organizationCode'] ?? "";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "organizationName": organizationName,
      "organizationCode": organizationCode,
    };
  }
}
