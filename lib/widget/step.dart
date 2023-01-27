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
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      child: Column(
        key: ValueKey('LoginTop-$step'),
        children: [
          GestureDetector(
            onLongPress: randomizeInputs,
            child: SizedBox(
              height: 100,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
              height: 80,
              child: LoginInput(
                inputCtrl: inputCtrl,
                step: step,
                onNext: onNext,
              ),
            ),
          ),
          if (agreementWidget != null && step == LoginStep.pwd)
            agreementWidget!,
          LoginNextButton(
            onNext: onNext,
            step: step,
            nextBuilder: nextBuilder,
          ),
        ],
      ),
    );
  }
}
