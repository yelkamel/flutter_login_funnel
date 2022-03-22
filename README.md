# 👥 flutter_login_funnel 😁

It's a **UX design** package to help you to build a login or register process quickly and simply.
You can but your UI widget with the builder parameter but all the logic transition will be **auto manage**.
You can also use play audio files from **network** using their url, **radios/livestream** and **local files**

**This can be used with any Authentification service provider with email/password**

[![sample1](./medias/login_funnel_preview.gif)](https://github.com/yelkamel/flutter_login_funnel)

<p align="center">
  <a href='https://imgur.com/7RqxtPc.mp4'>
    <img src='https://github.com/yelkamel/flutter_login_funnel/flutter_login/medias/login_funnel_preview.gif' width=320>
  </a>
</p>

## 📥 Import

```yaml
dependencies:
  flutter_login_funnel: ^0.0.2
  
or

  flutter_login_funnel:
    git:
      url: https://github.com/yelkamel/flutter_login_funnel
```

## 🧐 How to use

```Dart
 LoginFunnel(
      onFinish: () {},
      loadingWidget: const CircularProgressIndicator(),
      backWidget:  const Icon(Icons.arrow_back),
      onEmailValidation: (_) => _.length > 3,
      onPasswordValidation: (_) => _.length > 3,
      onNameValidation: (_) => _.length > 3,
      titleBuilder: (context, step) {
        switch (step) {
          case LoginStep.name:
            return Text("votre prénom");
          case LoginStep.email:
            return Text("votre email ?");
          case LoginStep.pwd:
            return Text("mot de passe ?");
          case LoginStep.loading:
            return Text("loading");
          case LoginStep.init:
            return Text("init");
        }
      },
      registerOrConnectBuilder: (context, onConnect, onRegister) => Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: onConnect,
              child: Text("Click here to connect"),
            ),
            MaterialButton(
              onPressed: onRegister,
              child: Text("Click here to register"),
            ),
          ],
        ),
      ),
      actionsBuilder: (context, step) => step == LoginStep.password ? 
            MaterialButton(
              onPressed: onConnect,
              child: Text("Reset Password request"),
            ) : const SizedBox();
      onAuthSubmit: (createAccount, name, email, pwd) async {
        if (!createAccount) {
          final res = await Auth.signInWithEmailAndPassword(email, pwd);
          if (!res) return false;
        }
        final res = await Auth.registerWithEmailAndPassword(email, pwd);
        if (!res) return false;
        Auth.updateDisplayName(name);
        onFinish.call();
        return true;
      },
    );
```


## 🤓 Reference

Property |   Type     | Description
-------- |------------| ---------------
onFinish |   `AuthCallback`     | <sub> When the the user is logged in If you use Auth stream strategy this is no needed.</sub>
onAuthSubmit | `AuthCallback` | <sub>Where you have to call your Authentification service provider with the email/password (and name if it's a registration) if the provider doesn't accept you can return false to stop the tunnel otherwise true Tips: don't forget to popup a snackbar to explain why the provider didn't accepte.</sub>
onLogin |   `AuthCallback`     | <sub>Called when the user hit the submit button when in login mode.</sub>
onEmailValidation | `Function` | <sub>this validation function is to validate the email if it's return false it's will don't go next.</sub>
onPasswordValidation |   `Function`     | <sub>this validation function is to validate the password if it's return false it's will don't go next.</sub>
onNameValidation | `Function` | <sub>this validation function is to validate the name if it's return false it's will don't go next.</sub>
titleBuilder | `Builder` | <sub>This will be show in the top for each step.</sub>
registerOrConnectBuilder | `Builder` | <sub>This will be show in the first step to as the use to connect or login use onConnect to call login and onRegister to register an user.</sub>
actionsBuilder | `Builder` | <sub>This is to build actions button for by step.</sub>
loadingWidget | `Widget` | <sub>This widget will be show when it's loading state.</sub>
backWidget | `Function` | <sub>This widget will be show as back button.</sub>



## License

* MIT License

[example project]: example/lib/main.dart