import 'package:flutter/material.dart';

import '../layou_package/fade_intout_transitionner.dart';
import '../main.dart';
import 'inputs.dart';
import 'next_button.dart';

class LoginStepWidget extends StatelessWidget {
  final TextEditingController inputCtrl;
  final LoginStep step;
  final bool createAccount;
  final void Function()? onNext;
  final Widget? agreementWidget;
  final Widget Function(
    BuildContext,
    LoginStep,
  )? titleBuilder;
  final Widget Function(
    BuildContext,
    LoginStep,
    void Function(),
  )? nextBuilder;

  const LoginStepWidget({
    Key? key,
    required this.inputCtrl,
    required this.step,
    this.createAccount = true,
    required this.onNext,
    this.titleBuilder,
    this.nextBuilder,
    this.agreementWidget,
  }) : super(key: key);

  double getStepValue() {
    if (step == LoginStep.name) return 0.3;
    if (step == LoginStep.email) return 0.6;
    if (step == LoginStep.pwd) return 0.9;
    return 1;
  }

  void randomizeInputs() {
    if (step == LoginStep.name) {
      inputCtrl.text = "name_${DateTime.now().millisecond}";
    }
    if (step == LoginStep.email) {
      inputCtrl.text = "${DateTime.now().millisecond}@yopmail.com";
    }
    if (step == LoginStep.pwd) {
      inputCtrl.text = "azerty";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('LoginTop-$step'),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: GestureDetector(
            onLongPress: randomizeInputs,
            child: Center(
              child: FadeInOutTransitionner(
                child: Padding(
                  key: Key(step.toString()),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: titleBuilder?.call(context, step) ??
                      LoginFunnelTopSectionWidgetUtils(step: step),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: LoginInput(
            inputCtrl: inputCtrl,
            step: step,
            onNext: onNext,
          ),
        ),
        if (agreementWidget != null && step == LoginStep.pwd) agreementWidget!,
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: LoginNextButton(
            onNext: onNext,
            step: step,
            nextBuilder: nextBuilder,
          ),
        ),
      ],
    );
  }
}
