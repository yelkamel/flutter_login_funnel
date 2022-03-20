part of flutter_login_funnel;

class LoginFunnel extends StatefulWidget {
  final void Function()? onClose;
  final Widget? loadingWidget;
  final Widget? backWidget;
  final void Function()? onFinish;
  final bool Function(String)? onNameValidation;
  final bool Function(String)? onEmailValidation;
  final bool Function(String)? onPasswordValidation;
  final Future<bool> Function(bool, String, String, String)? onAuthSubmit;
  final Widget Function(
    BuildContext,
    void Function() onConnect,
    void Function() onRegister,
  )? actionBuilder;
  final Widget Function(
    BuildContext,
    LoginStep,
  )? titleBuilder;

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
    this.actionBuilder,
    this.titleBuilder,
  }) : super(key: key);

  @override
  State<LoginFunnel> createState() => _LoginFunnelState();
}

class _LoginFunnelState extends State<LoginFunnel> {
  TextEditingController inputController = TextEditingController();
  LoginStep step = LoginStep.init;

  bool createAccount = true;
  String name = '';
  String email = '';
  String password = '';

  void nameFinish() {
    name = inputController.text.trim().capitalizeFirst;
    final res = widget.onNameValidation?.call(name) ?? true;
    if (!res) return;

    inputController.text = "";
    setState(() => step = LoginStep.email);
  }

  void emailFinish() {
    email = inputController.text.trim();
    final res = widget.onEmailValidation?.call(email) ?? true;
    if (!res) return;
    setState(() => step = LoginStep.pwd);
    inputController.text = "";
  }

  void pwdFinish() async {
    password = inputController.text.trim();
    final res = widget.onPasswordValidation?.call(password) ?? true;
    if (!res) return;

    setState(() => step = LoginStep.loading);

    final authRes =
        await widget.onAuthSubmit?.call(createAccount, name, email, password) ??
            false;

    if (!authRes) {
      setState(() => step = LoginStep.pwd);
      inputController.text = "";
      return;
    }

    widget.onFinish?.call();
  }

  void goNext() {
    debugPrint("[LoginFunnel]: Go Next from $step");
    if (step == LoginStep.pwd) pwdFinish();
    if (step == LoginStep.email) emailFinish();
    if (step == LoginStep.name) nameFinish();
  }

  void goBack() {
    debugPrint("[LoginFunnel]: Go Back from $step");
    final close = step == LoginStep.init && widget.onClose != null;
    if (close) widget.onClose?.call();

    if (step == LoginStep.name) setState(() => step = LoginStep.init);

    if (step == LoginStep.email) {
      step = createAccount ? LoginStep.name : LoginStep.init;
      inputController.text = name;
    }

    if (step == LoginStep.pwd) {
      setState(() => step = LoginStep.email);
      inputController.text = email;
    }
    if (step == LoginStep.loading) setState(() => step = LoginStep.pwd);
  }

  void onSubmitAction(bool _) {
    createAccount = _;
    setState(() => step = _ ? LoginStep.name : LoginStep.email);
  }

  void onRegister() {
    setState(() {
      createAccount = true;
      step = LoginStep.name;
    });
  }

  void onLogin() {
    setState(() {
      createAccount = false;
      step = LoginStep.email;
    });
  }

  Widget buildContent() {
    debugPrint("[LoginFunnel]: Build step: $step");

    switch (step) {
      case LoginStep.loading:
        return Center(
          key: const ValueKey('LoginFunnelLoading'),
          child: widget.loadingWidget ?? const CircularProgressIndicator(),
        );
      case LoginStep.init:
        return widget.actionBuilder?.call(context, onRegister, onLogin) ??
            LoginActionDefault(
              onLogin: onLogin,
              onRegister: onRegister,
            );
      default:
        return LoginTop(
          enableClose: widget.onClose != null,
          goBack: goBack,
          inputCtrl: inputController,
          onNext: goNext,
          step: step,
          titleBuilder: widget.titleBuilder,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RawMaterialButton(
          onPressed: goBack,
          child: widget.backWidget ?? const Icon(Icons.arrow_back),
        ),
      ),
      body: FadeInOutTransitionner(child: buildContent()),
    );
  }
}
