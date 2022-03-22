import 'package:flutter/material.dart';
import 'package:flutter_login_funnel/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testStepperChain();
  testAuthCase();
  testValidationCallBack();
}

void testValidationCallBack() {
  group('Validation call back tests', () {
    testWidgets("block if the email is not validate.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
          onEmailValidation: (_) => _.length > 3,
        ),
      ));
      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.email')),
        findsOneWidget,
      );
    });
    testWidgets("let passe if the email is valid.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
          onEmailValidation: (_) => _.length > 3,
        ),
      ));
      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.enterText(
          find.byKey(const ValueKey('LoginInputText-LoginStep.email')),
          "test12121@yopmail.com");

      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });

    testWidgets("block if the name is not validate.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
          onNameValidation: (_) => _.length > 3,
        ),
      ));
      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.name')),
        findsOneWidget,
      );
    });
    testWidgets("let passe if the name is valid.", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
          onEmailValidation: (_) => _.length > 3,
        ),
      ));
      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.enterText(
          find.byKey(const ValueKey('LoginInputText-LoginStep.name')),
          "test12121");

      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });

    testWidgets("block if the pwd is not validate.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
          onPasswordValidation: (_) => _.length > 3,
        ),
      ));
      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });
    testWidgets("let passe if the password is valid.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return true;
          },
          onPasswordValidation: (_) => _.length > 3,
          loadingWidget: SizedBox(),
        ),
      ));
      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
          "AZERTY123");
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginFunnelLoading')),
        findsOneWidget,
      );
    });
  });
}

void testStepperChain() {
  group('Stepper chain tests', () {
    testWidgets("Initilisation default login action",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('LoginActionDefault')), findsOneWidget);
    });
    testWidgets("Tap Register start with Name step.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));

      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.name')),
        findsOneWidget,
      );
    });

    testWidgets("Tap Register Follow Name -> Email step.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));

      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.email')),
        findsOneWidget,
      );
    });

    testWidgets("Tap Register Follow Name -> Email -> Password step.",
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));

      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });

    testWidgets("Tap SignIn Follow Email -> Password step.",
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.email')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });
  });
}

void testAuthCase() {
  group('Auth case tests', () {
    testWidgets("User try to login but not accepted by Auth service.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return false;
          },
        ),
      ));

      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('LoginInputText-LoginStep.pwd')),
        findsOneWidget,
      );
    });

    testWidgets("User to login and it's accepted by Auth service.",
        (WidgetTester tester) async {
      bool isFinish = false;
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            return true;
          },
          onFinish: () {
            isFinish = true;
          },
          loadingWidget: const SizedBox(),
        ),
      ));

      await tester
          .tap(find.byKey(const ValueKey('LoginActionDefault-register')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(isFinish, true);
    });

    testWidgets("User try to signin.", (WidgetTester tester) async {
      bool createAccountTmp = true;
      await tester.pumpWidget(MaterialApp(
        home: LoginFunnel(
          onAuthSubmit: (createdAccount, name, email, pwd) async {
            createAccountTmp = createdAccount;
            return false;
          },
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('LoginActionDefault-signin')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('LoginNextButton')));
      await tester.pumpAndSettle();
      expect(
        createAccountTmp,
        false,
      );
    });
  });
}
