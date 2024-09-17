import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Fluttertoast.showToast(
          msg: " Loghin Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
                    onPressed: _submitForm,
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
