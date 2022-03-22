part of flutter_login_funnel;

class LoginRegisterOrConnectDefault extends StatelessWidget {
  final void Function() onLogin;
  final void Function() onRegister;
  final String registerButtonLabel;
  final String alreadyAccountLabel;

  final String connectButtonLabel;
  const LoginRegisterOrConnectDefault({
    Key? key,
    required this.onLogin,
    required this.onRegister,
    this.registerButtonLabel = "Register",
    this.alreadyAccountLabel = "Already an account ?",
    this.connectButtonLabel = 'Sign In',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('LoginRegisterOrConnectDefault'),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                registerButtonLabel,
                key: const ValueKey('LoginRegisterOrConnectDefault-register'),
                style: Theme.of(context).textTheme.button!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onPressed: onRegister,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  alreadyAccountLabel,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                RawMaterialButton(
                  onPressed: onLogin,
                  key: const ValueKey('LoginRegisterOrConnectDefault-signin'),
                  child: Text(
                    connectButtonLabel,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
