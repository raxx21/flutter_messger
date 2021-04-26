import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/screens/loading.dart';
import 'package:flutter_ui_msg/services/auth.dart';
import 'package:flutter_ui_msg/widgets/textfield.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  //local variable
  String email = '';
  String userName = '';
  String phone = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                color: Colors.red,
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Text(
                            'FassBook',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            TextInput(
                              inputDecoration: textInputDecoration,
                              hintText: 'Enter Email',
                              onChange: (val) {
                                email = val;
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Enter your Email' : null,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextInput(
                              inputDecoration: textInputDecoration,
                              hintText: 'Enter Username',
                              onChange: (val) {
                                userName = val;
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Enter your Email' : null,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextInput(
                              inputDecoration: textInputDecoration,
                              hintText: 'Enter Phone',
                              onChange: (val) {
                                phone = val;
                              },
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextInput(
                              inputDecoration: textInputDecoration,
                              hintText: 'Enter Password',
                              onChange: (val) {
                                password = val;
                              },
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            ButtonTheme(
                              minWidth: double.infinity,
                              height: 40.0,
                              child: RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth
                                          .signUpWithEmailAndPassword(
                                              email, password, userName, phone);
                                      if (result == null) {
                                        setState(() {
                                          error = 'Please Enter a valid Email';
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(error),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      widget.toggleView();
                                    },
                                    child: Text(
                                      'Already a member?',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
    ;
  }
}
