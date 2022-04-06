library flutter_login_funnel;

import 'package:flutter/material.dart';

import 'layou_package/fade_intout_transitionner.dart';
import 'model/login_model.dart';
import 'widget/step.dart';

import './layou_package/extension_string.dart';

part 'login_enum.dart';

part 'default/register_or_connect.dart';
part 'default/top_section.dart';

class LoginFunnel extends StatefulWidget {
  /// This function is call when the user try to back at the first step.
  final void Function()? onClose;

  /// This widget will be show when it's loading state.
  final Widget? loadingWidget;

  /// This widget will be show as back button.
  final Widget? backWidget;

  /// When the the user is logged in
  /// If you use Auth stream strategy this is no needed.
  final void Function()? onFinish;

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
    void Function()? onNext,
  )? nextBuilder;

  /// This will be show in the top for each step.
  final Widget Function(
    BuildContext,
    LoginStep,
  )? titleBuilder;

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
  }) : super(key: key);

  @override
  State<LoginFunnel> createState() => _LoginFunnelState();
}

class _LoginFunnelState extends State<LoginFunnel> {
  TextEditingController inputController = TextEditingController();
  LoginStep step = LoginStep.init;

  bool createAccount = true;
  LoginModel loginModel = LoginModel();

  void nameFinish() {
    final name = inputController.text.trim().capitalizeFirst;
    final res = widget.onNameValidation?.call(name) ?? true;
    if (!res) return;
    loginModel.name = name;

    inputController.text = "";
    setState(() => step = LoginStep.email);
  }

  void emailFinish() {
    final email = inputController.text.trim();
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

    widget.onFinish?.call();
  }

  void goNext() {
    if (step == LoginStep.pwd) pwdFinish();
    if (step == LoginStep.email) emailFinish();
    if (step == LoginStep.name) nameFinish();
  }

  void goBack() {
    final close = step == LoginStep.init && widget.onClose != null;
    if (close) widget.onClose?.call();

    if (step == LoginStep.name) setState(() => step = LoginStep.init);

    if (step == LoginStep.email) {
      step = createAccount ? LoginStep.name : LoginStep.init;
      inputController.text = loginModel.name;
    }

    if (step == LoginStep.pwd) {
      setState(() => step = LoginStep.email);
      inputController.text = loginModel.email;
    }
    if (step == LoginStep.loading) setState(() => step = LoginStep.pwd);
  }

  void onSubmitAction(bool _) {
    createAccount = _;
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
          enableClose: widget.onClose != null,
          goBack: goBack,
          inputCtrl: inputController,
          onNext: goNext,
          step: step,
          titleBuilder: widget.titleBuilder,
          nextBuilder: widget.nextBuilder,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: step != LoginStep.init || widget.onClose != null
            ? RawMaterialButton(
                onPressed: goBack,
                child: widget.backWidget ?? const Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          if (widget.actionsBuilder != null)
            widget.actionsBuilder!(context, step, loginModel)
        ],
      ),
      body: FadeInOutTransitionner(child: buildContent()),
    );
  }
}
