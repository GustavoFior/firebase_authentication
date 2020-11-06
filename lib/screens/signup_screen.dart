import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_authentication/helpers/authenticationHelper.dart';
import 'package:firebase_authentication/stores/signup_store.dart';
import 'package:firebase_authentication/widgets/custom_icon_button.dart';
import 'package:firebase_authentication/widgets/custom_text_field.dart';

import 'list_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupStore signupStore = SignupStore();
  AuthenticationHelper authHelper = AuthenticationHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Vamos criar sua conta!"),
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
                    CustomTextField(
                      hint: 'E-mail',
                      prefix: Icon(Icons.account_circle),
                      textInputType: TextInputType.emailAddress,
                      onChanged: signupStore.setEmail,
                      enabled: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(builder: (_) {
                      return CustomTextField(
                        hint: 'Senha',
                        prefix: Icon(Icons.lock),
                        obscure: !signupStore.isPasswordVisibilty,
                        onChanged: signupStore.setPassword,
                        enabled: true,
                        suffix: CustomIconButton(
                          radius: 32,
                          iconData: signupStore.isPasswordVisibilty ? Icons.visibility_off : Icons.visibility,
                          onTap: signupStore.setPasswordVisibilty,
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Observer(builder: (_) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text('Criar conta'),
                          color: Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          onPressed: signupStore.isFormValid
                              ? () async {
                                  if (await authHelper.signupWithEmailAndPassword(signupStore.email, signupStore.password)) {
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
}
