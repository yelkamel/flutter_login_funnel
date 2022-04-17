part of flutter_login_funnel;

/// This is really simple Widget utils to show if the user want to connect or register
/// to use if you don't have time to work on UI UX of the login process.
class LoginFunnelRegisterOrConnectWidgetUtils extends StatelessWidget {
  final void Function() onRegister;
  final void Function() onConnect;
  final String registerButtonLabel;
  final String alreadyAccountLabel;

  final String connectButtonLabel;
  const LoginFunnelRegisterOrConnectWidgetUtils({
    Key? key,
    required this.onRegister,
    required this.onConnect,
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
                  onPressed: onConnect,
                  key: const ValueKey('LoginRegisterOrConnectDefault-signin'),
                  child: Text(
                    connectButtonLabel,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
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
