import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  _LoginStoreBase() {
    autorun((_) {
      print("email: $email");
      print("password: $password");
      print("isFormValid: $isFormValid");
    });
  }

  @observable
  String email = "gufior@gmail.com";
  @action
  void setEmail(String value) => email = value;

  @observable
  String password = "123456";
  @action
  void setPassword(String value) => password = value;

  @observable
  bool isPasswordVisibilty = false;
  @action
  void setPasswordVisibilty() => isPasswordVisibilty = !isPasswordVisibilty;

  @computed
  bool get isEmailValid => RegExp("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(email);

  @computed
  bool get isPasswordValid => password.length >= 5;

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;
}
