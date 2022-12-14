import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterchatapp/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function({
    required String email,
    required String password,
    required String username,
    required bool isLogin,
    File? image,
  }) submitAuthForm;
  final bool isLoading;

  const AuthForm({
    Key? key,
    required this.submitAuthForm,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  // ignore: prefer_typing_uninitialized_variables
  var _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); //remove keyboard

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      debugPrint(_userEmail);
      debugPrint(_userName);
      debugPrint(_userPassword);
      widget.submitAuthForm(
        email: _userEmail.trim(),
        password: _userPassword.trim(),
        username: _userName.trim(),
        isLogin: _isLogin,
        image: _userImageFile,
      );
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, //wrapping, so no extra space will be taken.
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      imagePickedFn: _pickedImage,
                    ),
                  TextFormField(
                    key: const ValueKey('Email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('User Name'),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.next,
                    ),
                  TextFormField(
                    key: const ValueKey('Password'),
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin ? 'Login' : 'SignUP',
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: (() {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      }),
                      child: Text(
                        _isLogin
                            ? 'Create New Account?'
                            : 'I already have an account.',
                      ),
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
