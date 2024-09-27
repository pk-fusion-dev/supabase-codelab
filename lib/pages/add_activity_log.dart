import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'dart:developer' as dev;
import 'package:supabase_lab/network/supabase_service.dart';

class NewActivityLog extends StatefulWidget {
  const NewActivityLog({super.key});

  @override
  State<NewActivityLog> createState() => _NewActivityLogState();
}

class _NewActivityLogState extends State<NewActivityLog> {
  final SupabaseService _authService = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _amountController = TextEditingController();
  String dropdownvalue = 'ACTIVATE_LICENSE';
  var _username = '';
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _businessNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void clearInput() {
    _userNameController.clear();
    _businessNameController.clear();
    _amountController.clear();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _userNameController.text = _username;
    });
  }

  String? _validateBusinessName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Business Name';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid Amount';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _authService
          .saveActivityLog(_businessNameController.text, dropdownvalue,
              _username, int.parse(_amountController.text))
          .then((value) {
        if (value == 'SUCCESS') {
          Navigator.pushReplacementNamed(context, 'home_screen');
        }
        clearInput();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: SizedBox(
          child: Card(
            margin: const EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      controller: _userNameController,
                      enabled: false,
                      //initialValue: _username,
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
                      validator: null),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _businessNameController,
                      obscureText: false,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_balance_outlined),
                          labelText: 'Business Name',
                          //helperText: 'Password is requird!',
                          //errorText: 'Username is empty!',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(4.0))
                              )),
                      validator: _validateBusinessName),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _amountController,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.monetization_on_outlined),
                          labelText: 'Total Amount',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(4.0))
                              )),
                      validator: _validateAmount),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: 'Service',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: DropdownMenu(
                          initialSelection: "ACTIVATE_LICENSE",
                          width: 335,
                          //focusNode: _focusNode,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                                value: "ACTIVATE_LICENSE",
                                label: "ACTIVATE_LICENSE"),
                            DropdownMenuEntry(
                                value: "SWITCH_LICENSE",
                                label: "SWITCH_LICENSE"),
                            DropdownMenuEntry(
                                value: "ACTIVATE_PC_CLIENT",
                                label: "ACTIVATE_PC_CLIENT"),
                            DropdownMenuEntry(
                                value: "ACTIVATE_MOBILE_CLIENT",
                                label: "ACTIVATE_MOBILE_CLIENT"),
                            DropdownMenuEntry(
                                value: "ACTIVATE_STARMAN",
                                label: "ACTIVATE_STARMAN"),
                            DropdownMenuEntry(
                                value: "EXTEND_TRIAL", label: "EXTEND_TRIAL"),
                            DropdownMenuEntry(
                                value: "EXTEND_LICENSE",
                                label: "EXTEND_LICENSE"),
                          ],
                          onSelected: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(
                          double.infinity, 50), // Set minimum width and height
                    ),
                    onPressed: _submitForm,
                    child: Text('SAVE',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
