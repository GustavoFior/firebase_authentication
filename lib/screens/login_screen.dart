import 'package:firebase_authentication/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_authentication/helpers/authenticationHelper.dart';
import 'package:firebase_authentication/stores/login_store.dart';
import 'package:firebase_authentication/widgets/custom_icon_button.dart';
import 'package:firebase_authentication/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginStore loginStore = LoginStore();
  AuthenticationHelper authHelper = AuthenticationHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Login"),
        ),
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _signInButton(),
                    _biometricButton(),
                    SizedBox(height: 25),
                    CustomTextField(
                      hint: 'E-mail',
                      prefix: Icon(Icons.account_circle),
                      textInputType: TextInputType.emailAddress,
                      onChanged: loginStore.setEmail,
                      enabled: true,
                    ),
                    SizedBox(height: 16),
                    Observer(builder: (_) {
                      return CustomTextField(
                        hint: 'Senha',
                        prefix: Icon(Icons.lock),
                        obscure: !loginStore.isPasswordVisibilty,
                        onChanged: loginStore.setPassword,
                        enabled: true,
                        suffix: CustomIconButton(
                          radius: 32,
                          iconData: loginStore.isPasswordVisibilty ? Icons.visibility_off : Icons.visibility,
                          onTap: loginStore.setPasswordVisibilty,
                        ),
                      );
                    }),
                    SizedBox(height: 16),
                    Observer(builder: (_) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text('Login'),
                          color: Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          onPressed: loginStore.isFormValid
                              ? () async {
                                  if (await authHelper.signinWithEmailAndPassword(loginStore.email, loginStore.password)) {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListScreen()));
                                  }
                                }
                              : null,
                        ),
                      );
                    })
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        // FIFI posso retornar assim ou bool
        await authHelper.signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SafeArea(
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Container(
                        margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Tarefas',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.exit_to_app),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              result.toString(),
                              style: TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Login com Google',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _biometricButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        // FIFI posso retornar assim ou bool
        await authHelper.signinWithBiometric().then((result) {
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SafeArea(
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Container(
                        margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Tarefas',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.exit_to_app),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              result.toString(),
                              style: TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Biometria',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
