/// This model is to store all the data for login.
class LoginModel {
  final String name;
  final String email;
  final String password;
  final String firstname;
  final bool createAccount;

  LoginModel({
    required this.name,
    required this.email,
    required this.password,
    required this.firstname,
    required this.createAccount,
  });

  @override
  String toString() =>
      "createAccount: $createAccount / name: $name / email: $email / password: $password";
}
