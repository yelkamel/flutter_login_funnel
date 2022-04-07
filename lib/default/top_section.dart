part of flutter_login_funnel;

/// This is really simple Widget utils to show the title of each step in english.
class LoginFunnelTopSectionWidgetUtils extends StatelessWidget {
  final LoginStep step;
  final String emailLabel;
  final String nameLabel;
  final String passwordLabel;
  const LoginFunnelTopSectionWidgetUtils({
    Key? key,
    required this.step,
    this.emailLabel = "What is your email ?",
    this.nameLabel = "Your name ?",
    this.passwordLabel = "What is your password ?",
  }) : super(key: key);

  String headerTitle() {
    switch (step) {
      case LoginStep.email:
        return emailLabel;
      case LoginStep.name:
        return nameLabel;
      case LoginStep.pwd:
        return passwordLabel;
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
