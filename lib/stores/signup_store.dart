import 'package:mobx/mobx.dart';
part 'signup_store.g.dart';

class SignupStore = _SignupStoreBase with _$SignupStore;

abstract class _SignupStoreBase with Store {
  _SignupStoreBase() {
    autorun(fn) {
      print("Passou SignupStore");
    }
  }

  @observable
  String email = "";
  @action
  void setEmail(String value) => email = value;

  @observable
  String password = "";
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
