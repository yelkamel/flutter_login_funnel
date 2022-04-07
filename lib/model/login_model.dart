/// This model is to store all the data for login.
class LoginModel {
  String name = '';
  String email = '';
  String password = '';
  bool createAccount = false;

  @override
  String toString() =>
      "createAccount: $createAccount / name: $name / email: $email / password: $password";
}
