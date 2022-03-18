part of flutter_login_funnel;

class LoginTop extends StatelessWidget {
  final bool? enableClose;
  final TextEditingController inputCtrl;
  final LoginStep step;
  final void Function() goBack;
  final bool createAccount;
  final void Function()? onNext;
  final Widget Function(
    BuildContext,
    LoginStep,
  )? titleBuilder;

  const LoginTop({
    this.enableClose,
    Key? key,
    required this.inputCtrl,
    required this.step,
    required this.goBack,
    this.createAccount = true,
    required this.onNext,
    this.titleBuilder,
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ProgressBar(value: getStepValue(state)),
        GestureDetector(
          onLongPress: randomizeInputs,
          child: SizedBox(
            height: 100,
            child: FadeInOutTransitionner(
              child: Padding(
                key: Key(step.toString()),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: titleBuilder?.call(context, step) ??
                    LoginFunnelTitleDefault(step: step),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: LoginInput(
            inputCtrl: inputCtrl,
            step: step,
            onNext: onNext,
          ),
        ),
        LoginNextButton(
          onNext: onNext,
          step: step,
        ),
      ],
    );
  }
}
