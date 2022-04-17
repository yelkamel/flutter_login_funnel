import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../main.dart';

/// This is the bottom area with the next button, we use a tab debouncer in there to provide us to make several api call at the same time.
class LoginNextButton extends StatelessWidget {
  final LoginStep step;
  final void Function()? onNext;
  final Widget Function(
    BuildContext,
    LoginStep,
    void Function(),
  )? nextBuilder;

  const LoginNextButton(
      {Key? key,
      required this.onNext,
      required this.step,
      this.nextBuilder,
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
          return nextBuilder?.call(context, step, onTap!) ??
              LoginFunnelNextButtonWidgetUtils(onPress: onTap!);
        },
      ),
    );
  }
}
