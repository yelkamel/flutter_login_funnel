import 'package:flutter/material.dart';

import '../main.dart';

/// This is the only input button of the process that provide the avability to have only one keyboard open.
class LoginInput extends StatefulWidget {
  final TextEditingController inputCtrl;
  final LoginStep step;
  final void Function()? onNext;

  const LoginInput({
    Key? key,
    required this.inputCtrl,
    required this.step,
    this.onNext,
  }) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  String text = "";
  bool hide = true;

  int getMaxLenght(LoginStep step) {
    if (step == LoginStep.name) return 50;
    if (step == LoginStep.pwd) return 50;
    return 250;
  }

  @override
  Widget build(BuildContext context) {
    double coef = 0.3;
    double fontSizedRatio = 1;

    if (text.length > 5) coef = 0.6;
    if (text.length > 10) coef = 0.8;
    if (text.length > 20) fontSizedRatio = 0.8;
    if (text.length > 25) fontSizedRatio = 0.6;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: TextField(
            key: ValueKey('LoginInputText-${widget.step}'),
            autofocus: true,
            textAlign: TextAlign.center,
            controller: widget.inputCtrl,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              suffixIcon: widget.step == LoginStep.pwd
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                        icon: Icon(
                          hide ? Icons.remove_red_eye : Icons.password,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    )
                  : null, //icon at tail of input
              counterText: '',
              hintText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 32,
                  ),
            ),
            onChanged: (value) => setState(() => text = value),
            autocorrect: false,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 32 * fontSizedRatio,
                ),
            enableSuggestions: widget.step != LoginStep.pwd,
            obscureText: widget.step == LoginStep.pwd && hide,
            onEditingComplete: widget.onNext,
            maxLength: getMaxLenght(widget.step),
          ),
        ),
        AnimatedContainer(
          height: 1,
          width: MediaQuery.of(context).size.width * coef,
          color: Theme.of(context).textTheme.bodyText1!.color,
          duration: const Duration(milliseconds: 500),
        )
      ],
    );
  }
}
