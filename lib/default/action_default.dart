part of flutter_login_funnel;

class LoginActionDefault extends StatelessWidget {
  final void Function() onLogin;
  final void Function() onRegister;

  const LoginActionDefault({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('LoginActionDefault'),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                "Register",
                key: const ValueKey('LoginActionDefault-register'),
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
                  'Already an account ?',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                RawMaterialButton(
                  onPressed: onLogin,
                  key: const ValueKey('LoginActionDefault-signin'),
                  child: Text(
                    'Sign In',
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
