import 'package:flutter/material.dart';

/// This is a simple next button widget that can be used in the login funnel by default.
class LoginFunnelNextButtonWidgetUtils extends StatelessWidget {
  final void Function() onPress;

  const LoginFunnelNextButtonWidgetUtils({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'Next',
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
