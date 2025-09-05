class CustomerRegisterPostRequest {
  String fullname;
  String email;
  String phone;
  String password;
  double money;

  CustomerRegisterPostRequest({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.password,
    required this.money,
  });

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "email": email,
    "phone": phone,
    "password": password,
    "money": money,
  };
}
