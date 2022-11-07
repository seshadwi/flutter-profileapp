import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;

  // Auth Instance
  FirebaseAuth auth = FirebaseAuth.instance;
  // Firestore Instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_controllerUsername.text.isNotEmpty &&
        _controllerPhone.text.isNotEmpty &&
        _controllerEmail.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firestore.collection('users').doc(uid).set({
            "username": _controllerUsername.text,
            "phone": _controllerPhone.text,
            "email": _controllerEmail.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    } else {
      print('Field Harus Diisi.');
    }
  }

  Widget _title() {
    return Text(isLogin ? 'Login' : 'Register');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
          isLogin ? 'Belum punya akun ? Register' : 'Sudah punya akun ? Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _title(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: isLogin
            ? <Widget>[
                _entryField('Email', _controllerEmail),
                // _entryField('email', _controllerEmail),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                // _entryField('password', _controllerPassword),
                const SizedBox(height: 20),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
              ]
            : <Widget>[
                _entryField('Username', _controllerUsername),
                const SizedBox(height: 20),
                _entryField('Phone Number', _controllerPhone),
                const SizedBox(height: 20),
                _entryField('Email', _controllerEmail),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
              ],
      ),
    );
  }
}
