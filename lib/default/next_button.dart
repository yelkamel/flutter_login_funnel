part of flutter_login_funnel;

/// This is a simple next button widget that can be used in the login funnel by default.
class LoginFunnelNextButtonWidgetUtils extends StatelessWidget {
  final void Function() onPress;
  final String? text;
  final Color? color;

  const LoginFunnelNextButtonWidgetUtils({
    Key? key,
    required this.onPress,
    this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      color: color ?? Theme.of(context).colorScheme.primary,
      child: Text(
        text ?? 'Next',
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
