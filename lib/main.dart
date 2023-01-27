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

  /// this validation function is to validate the Name if it's return false it's will don't go next.
  final bool Function(String)? onNameValidation;

  /// this validation function is to validate the Email if it's return false it's will don't go next.
  final bool Function(String)? onEmailValidation;

  /// this validation function is to validate the Password if it's return false it's will don't go next.
  final bool Function(String)? onPasswordValidation;

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

  const LoginFunnel({
    Key? key,
    this.loadingWidget,
    this.backWidget,
    this.onClose,
    this.onNameValidation,
    this.onEmailValidation,
    this.onPasswordValidation,
    required this.onAuthSubmit,
    this.onFinish,
    this.registerOrConnectBuilder,
    this.titleBuilder,
    this.actionsBuilder,
    this.nextBuilder,
    this.progressBarBuilder,
    this.initialStep,
    this.agreementWidget,
  }) : super(key: key);

  @override
  State<LoginFunnel> createState() => _LoginFunnelState();
}

class _LoginFunnelState extends State<LoginFunnel> {
  TextEditingController inputController = TextEditingController();
  late LoginStep step;
  LoginModel loginModel = LoginModel();

  LoginStep get initialStep => widget.initialStep ?? LoginStep.init;

  @override
  void initState() {
    super.initState();
    step = initialStep;
  }

  void nameFinish() {
    final name = inputController.text.trim().capitalizeFirst;
    final res = widget.onNameValidation?.call(name) ?? true;
    if (!res) return;
    loginModel.name = name;

    inputController.text = "";
    setState(() => step = LoginStep.email);
  }

  void emailFinish() {
    final email = inputController.text.trim().toLowerCase();
    final res = widget.onEmailValidation?.call(email) ?? true;
    if (!res) return;
    loginModel.email = email;

    setState(() => step = LoginStep.pwd);
    inputController.text = "";
  }

  void pwdFinish() async {
    final password = inputController.text.trim();
    final res = widget.onPasswordValidation?.call(password) ?? true;
    if (!res) return;
    loginModel.password = password;

    setState(() => step = LoginStep.loading);
    final authRes = await widget.onAuthSubmit?.call(loginModel) ?? false;

    if (!authRes) {
      setState(() => step = LoginStep.pwd);
      inputController.text = "";
      return;
    }

    widget.onFinish?.call(loginModel);
  }

  void goNext() {
    if (step == LoginStep.pwd) pwdFinish();
    if (step == LoginStep.email) emailFinish();
    if (step == LoginStep.name) nameFinish();
  }

  void goBack() {
    final close = step == initialStep && widget.onClose != null;
    if (close) {
      widget.onClose?.call();
      return;
    }

    LoginStep? targetStep;

    if (step == LoginStep.name) targetStep = LoginStep.init;

    if (step == LoginStep.email) {
      inputController.text = loginModel.name;
      targetStep = loginModel.createAccount ? LoginStep.name : LoginStep.init;
    }

    if (step == LoginStep.pwd) {
      inputController.text = loginModel.email;
      targetStep = LoginStep.email;
    }
    if (step == LoginStep.loading) targetStep = LoginStep.pwd;

    if (targetStep != null) setState(() => step = targetStep!);
  }

  void onSubmitAction(bool _) {
    loginModel.createAccount = _;
    setState(() => step = _ ? LoginStep.name : LoginStep.email);
  }

  void onRegister() {
    setState(() => step = LoginStep.name);
    loginModel.createAccount = true;
  }

  void onConnect() {
    setState(() => step = LoginStep.email);
    loginModel.createAccount = false;
  }

  Widget buildContent() {
    switch (step) {
      case LoginStep.loading:
        return Center(
          key: const ValueKey('LoginFunnelLoading'),
          child: widget.loadingWidget ?? const CircularProgressIndicator(),
        );
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: step == initialStep && widget.onClose == null
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
