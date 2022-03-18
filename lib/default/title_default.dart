part of flutter_login_funnel;

class LoginFunnelTitleDefault extends StatelessWidget {
  final LoginStep step;
  const LoginFunnelTitleDefault({Key? key, required this.step})
      : super(key: key);

  String headerTitle() {
    switch (step) {
      case LoginStep.email:
        return 'Email';
      case LoginStep.name:
        return 'Name';
      case LoginStep.pwd:
        return "Password";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        );

    return Text(
      headerTitle(),
      style: titleStyle,
      textAlign: TextAlign.center,
    );
  }
}
