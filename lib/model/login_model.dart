class LoginModel {
  String name = '';
  String email = '';
  String password = '';
  bool createAccount = false;

  @override
  String toString() =>
      "createAccount: $createAccount / name: $name / email: $email / password: $password";
}
