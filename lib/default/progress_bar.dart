part of flutter_login_funnel;

/// This is a simple progress bar widget that can be used in the login funnel by default.
class LoginFunnelProgressBarWidgetUtils extends StatelessWidget {
  final LoginStep step;
  final Color? progressColor;
  final Color? backgroundProgressColor;

  const LoginFunnelProgressBarWidgetUtils({
    Key? key,
    required this.step,
    this.progressColor,
    this.backgroundProgressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final witdth = MediaQuery.of(context).size.width;

    double getStepValue(LoginStep step) {
      if (step == LoginStep.init) return 0;
      if (step == LoginStep.firstname) return 0.2;
      if (step == LoginStep.name) return 0.4;
      if (step == LoginStep.email) return 0.6;
      if (step == LoginStep.pwd) return 0.9;

      return 1;
    }

    return Stack(
      children: [
        Container(
          width: witdth,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: backgroundProgressColor ??
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: witdth * getStepValue(step),
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: progressColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
