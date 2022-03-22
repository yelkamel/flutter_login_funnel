import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../main.dart';

class LoginNextButton extends StatelessWidget {
  final LoginStep step;
  final void Function()? onNext;
  final Widget? nextButton;
  const LoginNextButton(
      {Key? key,
      required this.onNext,
      required this.step,
      this.nextButton,
      state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (step == LoginStep.loading) return Container();

    return Padding(
      key: const ValueKey('LoginNextButton'),
      padding: const EdgeInsets.all(10.0),
      child: TapDebouncer(
        onTap: () async {
          onNext?.call();
        },
        builder: (BuildContext context, TapDebouncerFunc? onTap) {
          return GestureDetector(
            onTap: onTap,
            child: nextButton ??
                MaterialButton(
                  onPressed: onTap,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
          );
        },
      ),
    );
  }
}
