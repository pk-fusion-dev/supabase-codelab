import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../network/supabase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String dropdownvalue = 'Service';

  
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    } else if (!EmailValidator.validate(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  void _roleSelect(String? value) {
    // do something
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
        msg: " Register Success!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showErrorToast(String e) {
    Fluttertoast.showToast(
        msg: " Registeration Fail With $e !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _authService
            .signUp(_emailController.text, _passwordController.text,
                _userNameController.text, dropdownvalue)
            .whenComplete(() {
          clearInput();
          _showSuccessToast();
        });
      } catch (e) {
        _showErrorToast(e.toString());
      }
    }
  }

  void clearInput() {
    _emailController.clear();
    _userNameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        child: Card(
          margin: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    controller: _emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        //helperText: 'Password is requird!',
                        //errorText: 'Username is empty!',
                        border: OutlineInputBorder(
                            //borderRadius: BorderRadius.all(Radius.circular(4.0))
                            )),
                    validator: _validateEmail),
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: DropdownMenu(
                      initialSelection: "Service",
                      width: 335,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "Service", label: "Service"),
                        DropdownMenuEntry(
                            value: "Marketing", label: "Marketing"),
                      ],
                      onSelected: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          _roleSelect(newValue);
                        });
                      }),
                ),
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
                    'REGISTER',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
