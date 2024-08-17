import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});
  @override
  State<AuthenticateScreen> createState() {
    return _AuthenticateScreenState();
  }
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final _formkey = GlobalKey<FormState>();
  var visiblePassword = false;
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredusername = '';
  File? _selectedImage;
  String errorMssg = '';
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      errorMssg = 'The entered values are not valid.';
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMssg,
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    if (!_isLogin && _selectedImage == null) {
      errorMssg = 'No Image selected for profile.';
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMssg,
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    _formkey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
          
        final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredentials.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'username' : _enteredusername,
          'email' : _enteredEmail,
          'imageurl' : imageUrl, 
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }
    setState(() {
        _isAuthenticating = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(onImageSelect: (image) {
                              _selectedImage = image;
                            }),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          if(!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('UserName'),
                              ),
                              enableSuggestions: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter atleat 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredusername = newValue!;
                              },
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('Password'),
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: !visiblePassword,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 6) {
                                      return 'Password must be 6 characters long.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    visiblePassword = !visiblePassword;
                                  });
                                },
                                icon: visiblePassword
                                    ? Icon(Icons.visibility_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)
                                    : Icon(
                                        Icons.visibility_off_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if(_isAuthenticating)
                            const CircularProgressIndicator(),
                          if(!_isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'SignUp'),
                          ),
                          if(!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(!_isLogin
                                ? 'Already have an account'
                                : 'Create an Account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
