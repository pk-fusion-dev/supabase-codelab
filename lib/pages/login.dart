import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../network/supabase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool visible = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // Additional password validation logic if needed
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _authService
            .signInWithUsername(
                _userNameController.text, _passwordController.text)
            .then((value) {
          setState(() {
            visible = true;
          });

          _showSuccessToast();
          clearInput();
        });
      } catch (e) {
        _showErrorToast(e.toString());
      }
    }
  }

  Future<void> _logout() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _authService
          .signInWithUsername(
              _userNameController.text, _passwordController.text)
          .whenComplete(() {
        setState(() {
          visible = false;
        });
      });
    }
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
        msg: " Login Success!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showErrorToast(String e) {
    Fluttertoast.showToast(
        msg: " $e !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void clearInput() {
    _userNameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          child: Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          //helperText: 'Username is requird!',
                          prefixIcon: Icon(Icons.person),
                          //errorText: 'Username is empty!',
                          focusedBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(20)
                              ),
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(4.0))
                              )),
                      validator: _validateUserName),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Password',
                          //helperText: 'Password is requird!',
                          //errorText: 'Username is empty!',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(4.0))
                              )),
                      validator: _validatePassword),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(
                          double.infinity, 50), // Set minimum width and height
                    ),
                    onPressed: _login,
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Visibility(
                        visible: visible,
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => {_logout()},
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
