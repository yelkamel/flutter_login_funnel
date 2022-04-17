import 'package:flutter/material.dart';
import 'package:flutter_login_funnel/main.dart';

/// This is a simple progress bar widget that can be used in the login funnel by default.
class LoginFunnelProgressBarWidgetUtils extends StatelessWidget {
  final LoginStep step;

  const LoginFunnelProgressBarWidgetUtils({Key? key, required this.step})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final witdth = MediaQuery.of(context).size.width;

    double getStepValue(LoginStep step) {
      if (step == LoginStep.init) return 0;
      if (step == LoginStep.name) return 0.3;
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
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: witdth * getStepValue(step),
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
