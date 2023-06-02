library flutter_login_funnel;

import 'package:flutter/material.dart';

import 'layou_package/fade_intout_transitionner.dart';
import 'model/login_model.dart';
import 'widget/step.dart';

import './layou_package/extension_string.dart';

part 'login_enum.dart';

part 'default/register_or_connect.dart';
part 'default/top_section.dart';
part 'default/progress_bar.dart';
part 'default/next_button.dart';

class LoginFunnel extends StatefulWidget {
  /// This function is call when the user try to back at the first step.
  final void Function()? onClose;

  final LoginStep? initialStep;

  /// This widget will be show when it's loading state.
  final Widget? loadingWidget;

  /// This widget will be show as back button.
  final Widget? backWidget;

  /// This widget will be as aggreement when user signUp
  final Widget? agreementWidget;

  /// When the the user is logged in
  /// If you use Auth stream strategy this is no needed.
  final void Function(LoginModel)? onFinish;

  /// this validation function is to validate the steps if it's return false it's will don't go next.
  final bool Function(LoginStep, String)? onValidation;

  /// Where you have to call your Authentification service provider with the email/password (and name if it's a registration)
  /// if the provider doesn't accept you can return false to stop the tunnel otherwise true
  /// Tips: don't forget to popup a snackbar to explain why the provider didn't accepte.
  final Future<bool> Function(LoginModel)? onAuthSubmit;

  /// This will be show in the first step to as the use to connect or login
  /// use onConnect to call login and onRegister to register an user.
  final Widget Function(
    BuildContext,
    void Function() onRegister,
    void Function() onConnect,
  )? registerOrConnectBuilder;

  /// This is to have a custom next button for each step
  final Widget Function(
    BuildContext,
    LoginStep,
    void Function() onNext,
  )? nextBuilder;

  /// This will be show in the top for each step.
  final Widget Function(
    BuildContext,
    LoginStep,
  )? titleBuilder;

  /// This will show the progress of the funnel in the top for the user to know what's going on.
  final Widget Function(
    BuildContext,
    LoginStep,
  )? progressBarBuilder;

  /// This is to build actions button for by step.
  final Widget Function(
    BuildContext,
    LoginStep,
    LoginModel,
  )? actionsBuilder;

  ///
  final List<LoginStep> steps;

  const LoginFunnel({
    Key? key,
    this.loadingWidget,
    this.backWidget,
    this.onClose,
    this.onValidation,
    required this.onAuthSubmit,
    this.onFinish,
    this.registerOrConnectBuilder,
    this.titleBuilder,
    this.actionsBuilder,
    this.nextBuilder,
    this.progressBarBuilder,
    this.initialStep,
    this.agreementWidget,
    this.steps = const [
      LoginStep.init,
      LoginStep.name,
      LoginStep.email,
      LoginStep.pwd
    ],
  }) : super(key: key);

  @override
  State<LoginFunnel> createState() => _LoginFunnelState();
}

class _LoginFunnelState extends State<LoginFunnel> {
  TextEditingController inputController = TextEditingController();
  int indexStep = 0;
  bool loading = false;
  String name = "";
  String email = "";
  String password = "";
  String firstname = "";
  bool createAccount = true;

  void nameFinish() {
    name = inputController.text.trim().capitalizeFirst;
    final res = widget.onValidation?.call(LoginStep.name, name) ?? true;
    if (!res) return;
    inputController.text = "";
    setState(() => indexStep++);
  }

  void firstNameFinish() {
    firstname = inputController.text.trim().capitalizeFirst;
    final res =
        widget.onValidation?.call(LoginStep.firstname, firstname) ?? true;
    if (!res) return;
    inputController.text = "";
    setState(() => indexStep++);
  }

  void emailFinish() {
    email = inputController.text.trim().toLowerCase();
    final res = widget.onValidation?.call(LoginStep.email, email) ?? true;
    if (!res) return;
    inputController.text = "";
    setState(() => indexStep++);
  }

  void pwdFinish() async {
    password = inputController.text.trim();
    final res = widget.onValidation?.call(LoginStep.pwd, password) ?? true;
    if (!res) return;

    setState(() => loading = true);
    final loginModel = LoginModel(
      name: name,
      email: email,
      password: password,
      firstname: firstname,
      createAccount: createAccount,
    );
    final authRes = await widget.onAuthSubmit?.call(loginModel) ?? false;

    if (!authRes) {
      inputController.text = "";
      final indexEmailStep = widget.steps.indexOf(LoginStep.email);
      setState(() {
        loading = false;
        indexStep = indexEmailStep;
      });
      return;
    }

    widget.onFinish?.call(loginModel);
  }

  void goNext() {
    final step = widget.steps[indexStep];
    if (step == LoginStep.pwd) pwdFinish();
    if (step == LoginStep.firstname) firstNameFinish();
    if (step == LoginStep.email) emailFinish();
    if (step == LoginStep.name) nameFinish();
  }

  void goBack() {
    final step = widget.steps[indexStep];

    final close = indexStep == 0 && widget.onClose != null;
    if (close) {
      widget.onClose?.call();
      return;
    }

    if (step == LoginStep.email) {
      if (!createAccount) {
        setState(() => indexStep = 0);
        return;
      }
      inputController.text = name;
    }

    if (step == LoginStep.pwd) {
      inputController.text = email;
    }
    setState(() => indexStep--);
  }

  void onRegister() {
    inputController.text = "";
    setState(() {
      createAccount = true;
      indexStep = indexStep + 1;
    });
  }

  void onConnect() {
    inputController.text = "";
    final indexEmailStep = widget.steps.indexOf(LoginStep.email);
    setState(() {
      createAccount = false;
      indexStep = indexEmailStep;
    });
  }

  Widget buildContent() {
    final step = widget.steps[indexStep];

    if (loading) {
      return Center(
        key: const ValueKey('LoginFunnelLoading'),
        child: widget.loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    switch (step) {
      case LoginStep.init:
        return widget.registerOrConnectBuilder
                ?.call(context, onRegister, onConnect) ??
            LoginFunnelRegisterOrConnectWidgetUtils(
              onRegister: onRegister,
              onConnect: onConnect,
            );
      default:
        return LoginStepWidget(
          inputCtrl: inputController,
          onNext: goNext,
          step: step,
          titleBuilder: widget.titleBuilder,
          nextBuilder: widget.nextBuilder,
          agreementWidget: widget.agreementWidget,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[indexStep];
    final loginModel = LoginModel(
      name: name,
      email: email,
      password: password,
      firstname: firstname,
      createAccount: createAccount,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: indexStep == 0 && widget.onClose == null
            ? null
            : RawMaterialButton(
                onPressed: goBack,
                child: widget.backWidget ?? const Icon(Icons.arrow_back),
              ),
        actions: [
          if (widget.actionsBuilder != null)
            widget.actionsBuilder!(context, step, loginModel)
        ],
      ),
      body: Column(
        children: [
          widget.progressBarBuilder?.call(context, step) ??
              LoginFunnelProgressBarWidgetUtils(step: step),
          Expanded(child: FadeInOutTransitionner(child: buildContent())),
        ],
      ),
    );
  }
}
